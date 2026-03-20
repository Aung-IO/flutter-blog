import 'package:flutter/material.dart';
import 'package:flutter_blog/models/home_tab_config.dart';
import 'package:flutter_blog/pages/feat.dart';
import 'package:flutter_blog/widgets/home/home_app_bar.dart';
import 'package:flutter_blog/widgets/home/home_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final _featKey = GlobalKey<MessageFeatState>();

  late final List<TabItem> _tabs = HomeTabs.build(
    featKey: _featKey,
    onCreateSaved: () {
      _featKey.currentState?.refresh();
      if (!mounted) return;
      setState(() {
        _selectedIndex = 0;
      });
    },
  );

  @override
  Widget build(BuildContext context) {
    final activeTab = _tabs[_selectedIndex];

    return Scaffold(
      appBar: HomeAppBar(title: activeTab.title, subtitle: activeTab.subtitle),
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs.map((tab) => tab.page).toList(growable: false),
      ),
      extendBody: true,
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: _selectedIndex,
        destinations: _tabs
            .map((tab) => tab.destination)
            .toList(growable: false),
        onDestinationSelected: (index) {
          if (index == 0) _featKey.currentState?.refresh();
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
