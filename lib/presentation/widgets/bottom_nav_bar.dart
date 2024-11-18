import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/presentation/screens/app/provider/app_notifier_provider.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appNotifier = ref.read(appNotifierProvider.notifier);
    final appState = ref.watch(appNotifierProvider);

    return AnimatedBottomNavigationBar(
      icons: const [Icons.home, Icons.person],
      activeIndex: appState.bottomNavIndex,
      activeColor: main_color,
      gapLocation: GapLocation.center,
      onTap: (index) => appNotifier.updateBottomNavIndex(index),
    );
  }
}
