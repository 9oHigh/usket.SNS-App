import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
