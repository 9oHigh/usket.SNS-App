import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/di/injector.dart';
import 'package:sns_app/core/router/router.dart';
import 'package:sns_app/firebase_options.dart';
import 'package:sns_app/presentation/routers/custom_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await provideDatabases();
  provideDataSources();
  provideRepositories();
  provideUseCases();
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        // 어플리케이션 메인 컬러 정해지면 수정하기
        colorScheme: ColorScheme.fromSeed(seedColor: main_color),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white)),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
