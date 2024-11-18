import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/presentation/screens/app/provider/app_notifier_provider.dart';
import 'package:sns_app/presentation/screens/feed/feed_screen.dart';
import 'package:sns_app/presentation/screens/profile/profile_screen.dart';
import 'package:sns_app/presentation/widgets/bottom_nav_bar.dart';
import 'package:sns_app/presentation/widgets/custom_floating_button.dart';

class AppScreen extends ConsumerStatefulWidget {
  const AppScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends ConsumerState<AppScreen> {

  final List<Widget> screens = [
    const FeedScreen(),
    const ProfileScreen(userId: ""),
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appNotifierProvider);
    return Scaffold(
      appBar: AppBar(
          title: const Text("SNS",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: main_color))),
      body: screens[state.bottomNavIndex],
      floatingActionButton: const CreatePostFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
