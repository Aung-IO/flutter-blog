import 'package:flutter/material.dart';
import 'package:flutter_blog/core/constants/app_colors.dart';
import 'package:flutter_blog/pages/create.dart';
import 'package:flutter_blog/pages/feat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final _featKey = GlobalKey<MessageFeatState>();

  late final List<_TabItem> _tabs = [
    _TabItem(
      title: 'Feat',
      subtitle: 'Featured stories, categories, and trends.',
      page: MessageFeat(key: _featKey),
      destination: const NavigationDestination(
        icon: Icon(Icons.explore_outlined),
        selectedIcon: Icon(Icons.explore_rounded),
        label: 'Feat',
      ),
    ),
    _TabItem(
      title: 'Search',
      subtitle: 'Today\'s highlights.',
      page: const _DashboardTab(),
      destination: const NavigationDestination(
        icon: Icon(Icons.search_outlined),
        selectedIcon: Icon(Icons.search_rounded),
        label: 'Search',
      ),
    ),

    _TabItem(
      title: 'Create',
      subtitle: 'Draft a new post and organize your ideas.',
      page: CreateMessagePage(
        onSaved: () {
          _featKey.currentState?.refresh();
          if (!mounted) return;
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),
      destination: const NavigationDestination(
        icon: Icon(Icons.edit_outlined),
        selectedIcon: Icon(Icons.edit_rounded),
        label: 'Create',
      ),
    ),
    _TabItem(
      title: 'Profile',
      subtitle: 'Your stats, saved posts, and audience.',
      page: const _ProfileTab(),
      destination: const NavigationDestination(
        icon: Icon(Icons.person_outline_rounded),
        selectedIcon: Icon(Icons.person_rounded),
        label: 'Profile',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeTab = _tabs[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 84,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activeTab.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              activeTab.subtitle,
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
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs.map((tab) => tab.page).toList(growable: false),
      ),
      extendBody: true,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 28,
                offset: Offset(0, 20),
              ),
            ],
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(color: AppColors.onDark, size: 24);
                }

                return const IconThemeData(
                  color: AppColors.iconInactive,
                  size: 22,
                );
              }),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    color: AppColors.onDark,
                    fontWeight: FontWeight.w700,
                  );
                }

                return const TextStyle(
                  color: AppColors.iconInactive,
                  fontWeight: FontWeight.w600,
                );
              }),
            ),
            child: NavigationBar(
              height: 76,
              backgroundColor: AppColors.transparent,
              indicatorColor: AppColors.primary,
              surfaceTintColor: AppColors.transparent,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                if (index == 0) _featKey.currentState?.refresh();
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: _tabs
                  .map((tab) => tab.destination)
                  .toList(growable: false),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.title,
    required this.subtitle,
    required this.page,
    required this.destination,
  });

  final String title;
  final String subtitle;
  final Widget page;
  final NavigationDestination destination;
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

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
                    child: _StatChip(value: '24', label: 'Drafts'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatChip(value: '18k', label: 'Readers'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatChip(value: '92%', label: 'Engaged'),
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
              child: _ActionCard(
                icon: Icons.auto_awesome_rounded,
                title: 'Ideas',
                subtitle: 'Collect angles for your next piece.',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
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
              child: _ActionCard(
                icon: Icons.bar_chart_rounded,
                title: 'Analytics',
                subtitle: 'Spot the articles readers finish.',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
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

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

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
                      child: _MetricTile(value: '128', label: 'Posts'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _MetricTile(value: '42k', label: 'Views'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _MetricTile(value: '4.9', label: 'Rating'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        const _ProfileOption(
          icon: Icons.palette_outlined,
          title: 'Appearance',
          subtitle: 'Tune colors, reading density, and layout.',
        ),
        const SizedBox(height: 12),
        const _ProfileOption(
          icon: Icons.security_outlined,
          title: 'Privacy',
          subtitle: 'Manage visibility, drafts, and backups.',
        ),
        const SizedBox(height: 12),
        const _ProfileOption(
          icon: Icons.groups_2_outlined,
          title: 'Audience',
          subtitle: 'Understand who reads and follows your work.',
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.onDark.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.onDark,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.surfaceAccent)),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.surfaceAccent,
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.surfaceAccent,
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
