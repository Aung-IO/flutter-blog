import 'package:flutter/material.dart';
import 'package:flutter_blog/core/constants/app_colors.dart';

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final List<NavigationDestination> destinations;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: destinations,
          ),
        ),
      ),
    );
  }
}
