import 'package:flutter/material.dart';
import 'package:flutter_blog/core/constants/app_colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Size get preferredSize => const Size.fromHeight(84);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      toolbarHeight: 84,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.surfaceAccent,
            child: Icon(
              Icons.notifications_none_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
