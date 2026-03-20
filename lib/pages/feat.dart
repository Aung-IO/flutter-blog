import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blog/core/constants/app_colors.dart';
import 'package:flutter_blog/models/message.dart';
import 'package:flutter_blog/pages/create.dart';
import 'package:flutter_blog/repositories/message_repository.dart';

class MessageFeat extends StatefulWidget {
  const MessageFeat({super.key});

  @override
  MessageFeatState createState() => MessageFeatState();
}

class MessageFeatState extends State<MessageFeat> {
  List<Message> _messages = [];
  bool _loading = true;

  // load all messages from the database when the widget is first created
  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() => _loading = true);
    final messages = await ContactRepository.getMessages();
    if (mounted) {
      setState(() {
        _messages = messages;
        _loading = false;
      });
    }
  }

  /// Called by [HomeScreen] whenever the Feat tab is selected.
  void refresh() => _loadMessages();

  Future<void> _openEditPage(Message msg) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text('Edit Message'),
            backgroundColor: AppColors.transparent,
            elevation: 0,
          ),
          body: CreateMessagePage(message: msg),
        ),
      ),
    );
    if (updated == true) _loadMessages();
  }

  Future<void> _confirmDelete(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete message'),
        content: const Text('This message will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ContactRepository.deleteMessage(id);
      _loadMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Go to the Create tab to add your first message.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      itemCount: _messages.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return _MessageCard(
          message: msg,
          onEdit: () => _openEditPage(msg),
          onDelete: () => _confirmDelete(msg.id!),
        );
      },
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.message,
    required this.onEdit,
    required this.onDelete,
  });

  final Message message;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage =
        message.imagePath != null && File(message.imagePath!).existsSync();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasImage)
            Image.file(
              File(message.imagePath!),
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.danger,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
