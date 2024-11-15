import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/presentation/screens/feed/provider/feed_notifier_provider.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedNotifier = ref.read(feedNotifierProvider.notifier);
    final feedState = ref.watch(feedNotifierProvider);
    return AnimatedBottomNavigationBar(
      icons: const [Icons.home, Icons.search, Icons.person, Icons.settings],
      activeIndex: feedState.bottomNavIndex,
      activeColor: main_color,
      gapLocation: GapLocation.center,
      onTap: (index) => feedNotifier.updateBottomNavIndex(index),
      //other params
    );
  }
}
