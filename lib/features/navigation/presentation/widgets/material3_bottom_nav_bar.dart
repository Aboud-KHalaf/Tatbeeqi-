import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final destinations = [
      NavigationDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: l10n.navHome,
      ),
      NavigationDestination(
        icon: const Icon(Icons.school_outlined),
        selectedIcon: const Icon(Icons.school),
        label: l10n.navCourses,
      ),
      NavigationDestination(
        icon: const Icon(Icons.forum_outlined),
        selectedIcon: const Icon(Icons.forum),
        label: l10n.navCommunity,
      ),
      NavigationDestination(
        icon: const Icon(Icons.more_horiz_outlined),
        selectedIcon: const Icon(Icons.more_horiz),
        label: l10n.navMore,
      ),
    ];

    return NavigationBar(
      elevation: 0,
      selectedIndex: currentIndex.clamp(0, 3), // Ensure valid index
      onDestinationSelected: onTap,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: colorScheme.surfaceTint,
      indicatorColor: colorScheme.secondaryContainer,
      height: 70,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      animationDuration: const Duration(milliseconds: 200),
      destinations: destinations,
    );
  }
}
