import 'package:flutter/material.dart';
import 'package:flutter_blog/pages/create.dart';
import 'package:flutter_blog/pages/dashboard.dart';
import 'package:flutter_blog/pages/feat.dart';
import 'package:flutter_blog/pages/profile.dart';

/// Represents a single tab in the home screen navigation.
class TabItem {
  const TabItem({
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

/// Factory for building home screen tab configuration.
class HomeTabs {
  /// Builds the list of tabs for the home screen.
  ///
  /// Requires [featKey] to refresh the Feat tab and [onCreateSaved] callback
  /// to handle navigation after a message is created.
  static List<TabItem> build({
    required GlobalKey<MessageFeatState> featKey,
    required VoidCallback onCreateSaved,
  }) {
    return [
      TabItem(
        title: 'Feat',
        subtitle: 'Featured stories, categories, and trends.',
        page: MessageFeat(key: featKey),
        destination: const NavigationDestination(
          icon: Icon(Icons.all_inclusive),
          selectedIcon: Icon(Icons.all_inclusive),
          label: 'Feat',
        ),
      ),
      TabItem(
        title: 'Explore',
        subtitle: 'Today\'s highlights.',
        page: const DashboardTab(),
        destination: const NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore_rounded),
          label: 'Explore',
        ),
      ),
      TabItem(
        title: 'Create',
        subtitle: 'Draft a new post and organize your ideas.',
        page: CreateMessagePage(onSaved: onCreateSaved),
        destination: const NavigationDestination(
          icon: Icon(Icons.add_circle),
          selectedIcon: Icon(Icons.add_circle),
          label: 'Create',
        ),
      ),
      TabItem(
        title: 'Profile',
        subtitle: 'Your stats, saved posts, and audience.',
        page: const ProfileTab(),
        destination: const NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ),
    ];
  }
}
