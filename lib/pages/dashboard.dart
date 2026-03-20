import 'package:flutter/material.dart';
import 'package:flutter_blog/core/constants/app_colors.dart';
import 'package:flutter_blog/widgets/home/action_card.dart';
import 'package:flutter_blog/widgets/home/stat_chip.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              colors: [
                AppColors.primaryLight,
                AppColors.primaryMedium,
                AppColors.primaryDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.onDark.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Editorial dashboard',
                  style: TextStyle(
                    color: AppColors.onDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Keep your blog active with clear momentum and a sharper reading flow.',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.onDark,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Track what is performing, continue drafts, and surface the next story to publish.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.surfaceAccent,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Expanded(
                    child: StatChip(value: '24', label: 'Drafts'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatChip(value: '18k', label: 'Readers'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatChip(value: '92%', label: 'Engaged'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Quick actions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        const Row(
          children: [
            Expanded(
              child: ActionCard(
                icon: Icons.auto_awesome_rounded,
                title: 'Ideas',
                subtitle: 'Collect angles for your next piece.',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ActionCard(
                icon: Icons.schedule_rounded,
                title: 'Schedule',
                subtitle: 'Queue stories for the week ahead.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: ActionCard(
                icon: Icons.bar_chart_rounded,
                title: 'Analytics',
                subtitle: 'Spot the articles readers finish.',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ActionCard(
                icon: Icons.bookmark_added_rounded,
                title: 'Saved',
                subtitle: 'Return to references and notes.',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
