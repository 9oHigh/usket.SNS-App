import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/manager/alert_manager.dart';
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
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appNotifierProvider);

    _requestNotificationPermission();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hwi's SNS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                // MARK: - 알림 화면 이동
              },
              icon: Badge(
                isLabelVisible: appState.notificationCount > 0 ? true : false,
                label: Text("${appState.notificationCount}"),
                offset: const Offset(8, 8),
                backgroundColor: Colors.red,
                child: const Icon(
                  Icons.notifications,
                  size: 24,
                ),
              )),
        ],
        backgroundColor: main_color,
      ),
      body: screens[appState.bottomNavIndex],
      floatingActionButton: const CreatePostFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Future<void> _requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (status.isGranted) {
      return;
    } else if (status.isDenied || status.isPermanentlyDenied) {
      AlertManager.showNotificationPermissionAlert(context);
    } else {
      await Permission.notification.request();
    }
  }
}
