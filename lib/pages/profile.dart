import 'package:flutter/material.dart';
import 'package:flutter_blog/core/constants/app_colors.dart';
import 'package:flutter_blog/widgets/home/metric_tile.dart';
import 'package:flutter_blog/widgets/home/profile_option.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.surfaceAccent,
                  child: Icon(
                    Icons.person_rounded,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Apex Writer',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Building clean mobile writing experiences.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(
                      child: MetricTile(value: '128', label: 'Posts'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: MetricTile(value: '42k', label: 'Views'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: MetricTile(value: '4.9', label: 'Rating'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        const ProfileOption(
          icon: Icons.palette_outlined,
          title: 'Appearance',
          subtitle: 'Tune colors, reading density, and layout.',
        ),
        const SizedBox(height: 12),
        const ProfileOption(
          icon: Icons.security_outlined,
          title: 'Privacy',
          subtitle: 'Manage visibility, drafts, and backups.',
        ),
        const SizedBox(height: 12),
        const ProfileOption(
          icon: Icons.groups_2_outlined,
          title: 'Audience',
          subtitle: 'Understand who reads and follows your work.',
        ),
      ],
    );
  }
}
