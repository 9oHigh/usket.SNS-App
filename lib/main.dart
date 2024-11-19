import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/di/injector.dart';
import 'package:sns_app/core/manager/shared_preferences_manager.dart';
import 'package:sns_app/core/router/router.dart';
import 'package:sns_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPreferenceManager().initialize();
  await _initializeFCM();
  await provideDatabases();
  provideDataSources();
  provideRepositories();
  provideUseCases();
  final isLoggedIn =
      SharedPreferenceManager().getPref<bool>(PrefsType.isLoggedIn) ?? false;
  runApp(ProviderScope(
    child: MyApp(
      isLoggedIn: isLoggedIn,
    ),
  ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  int count = (SharedPreferenceManager()
              .getPref<int>(PrefsType.unReadNotificationCount) ??
          0) +
      1;
  SharedPreferenceManager()
      .setPref<int>(PrefsType.unReadNotificationCount, count);
  // MARK: - 알림에 표시 적용
}

Future<void> _initializeFCM() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max));
  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher")));
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: main_color),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white)),
        useMaterial3: true,
      ),
      routerConfig: createRouter(isLoggedIn),
    );
  }
}
