import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blog/core/constants/app_colors.dart';
import 'package:flutter_blog/models/message.dart';
import 'package:flutter_blog/repositories/message_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CreateMessagePage extends StatefulWidget {
  const CreateMessagePage({super.key, this.message, this.onSaved});

  /// Pass a [Message] to enable edit mode; null means create mode.
  final Message? message;
  final VoidCallback? onSaved;

  @override
  State<CreateMessagePage> createState() => _CreateMessagePageState();
}

class _CreateMessagePageState extends State<CreateMessagePage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  late final TextEditingController _titleController;
  late final TextEditingController _messageController;
  String? _imagePath;
  bool _saving = false;

  bool get _isEditing => widget.message != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.message?.title ?? '');
    _messageController = TextEditingController(
      text: widget.message?.message ?? '',
    );
    _imagePath = widget.message?.imagePath;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 80);
      if (picked != null && mounted) {
        final persistedPath = await _persistPickedImage(picked);
        if (!mounted) return;
        setState(() => _imagePath = persistedPath);
      }
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to open ${source == ImageSource.gallery ? 'gallery' : 'camera'}: ${e.message ?? e.code}',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on FileSystemException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to process selected image: ${e.message}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<String> _persistPickedImage(XFile picked) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/message_images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    final extension = picked.name.contains('.')
        ? picked.name.substring(picked.name.lastIndexOf('.'))
        : '.jpg';
    final targetPath =
        '${imageDir.path}/${DateTime.now().millisecondsSinceEpoch}$extension';

    final bytes = await picked.readAsBytes();
    final savedFile = await File(targetPath).writeAsBytes(bytes, flush: true);
    return savedFile.path;
  }

  Future<void> _openImageSource(ImageSource source) async {
    Navigator.pop(context);
    // Wait for the bottom sheet to close before opening the native picker.
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    await _pickImage(source);
  }

  void _showImageSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => _openImageSource(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () => _openImageSource(ImageSource.camera),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      final msg = Message(
        id: widget.message?.id,
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        imagePath: _imagePath,
      );
      if (_isEditing) {
        await ContactRepository.updateMessage(msg);
      } else {
        await ContactRepository.addMessage(msg);
        _titleController.clear();
        _messageController.clear();
        setState(() => _imagePath = null);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Message updated.' : 'Message saved.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        if (_isEditing) {
          Navigator.pop(context, true);
        } else {
          widget.onSaved?.call();
        }
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEditing ? 'Edit message' : 'New message',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEditing
                        ? 'Update the details below and save.'
                        : 'Fill in the title, body, and an optional image.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const _FieldLabel(text: 'Title'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _inputDecoration('Enter a title…'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Title is required'
                        : null,
                  ),
                  const SizedBox(height: 18),
                  const _FieldLabel(text: 'Message'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _messageController,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _inputDecoration('Write your message…'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Message is required'
                        : null,
                  ),
                  const SizedBox(height: 18),
                  const _FieldLabel(text: 'Image'),
                  const SizedBox(height: 8),
                  _ImagePickerWidget(
                    imagePath: _imagePath,
                    onTap: _showImageSourceSheet,
                    onRemove: () => setState(() => _imagePath = null),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _saving ? null : _save,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.onDark,
                              ),
                            )
                          : Text(_isEditing ? 'Update' : 'Save message'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.surfaceMuted,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _ImagePickerWidget extends StatelessWidget {
  const _ImagePickerWidget({
    required this.imagePath,
    required this.onTap,
    required this.onRemove,
  });

  final String? imagePath;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      final imageFile = File(imagePath!);
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.file(
              imageFile,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Image file is unavailable.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.close,
                  color: AppColors.onDark,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 36,
              color: AppColors.textMuted,
            ),
            SizedBox(height: 8),
            Text(
              'Tap to attach an image',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
