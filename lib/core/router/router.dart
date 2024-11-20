import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/presentation/screens/app/app_screen.dart';
import 'package:sns_app/presentation/screens/create_post/create_post_screen.dart';
<<<<<<< HEAD
import 'package:sns_app/presentation/screens/profile/edit_profile_screen.dart';
=======
import 'package:sns_app/presentation/screens/create_post/create_post_second_screen.dart';
import 'package:sns_app/presentation/screens/notification/notification_screen.dart';
>>>>>>> feat/notification
import 'package:sns_app/presentation/screens/signin/signin_screen.dart';
import 'package:sns_app/presentation/screens/signup/signup_first_screen.dart';
import 'package:sns_app/presentation/screens/signup/signup_second_screen.dart';
import 'package:sns_app/presentation/screens/signup/signup_third_screen.dart';

GoRouter createRouter(bool isLoggedIn) {
  return GoRouter(
    initialLocation: isLoggedIn ? '/app' : '/signin',
    routes: [
      GoRoute(
        path: "/signin",
        pageBuilder: (context, state) =>
            const CupertinoPage(child: SigninScreen()),
      ),
      GoRoute(
        path: "/signUpFirst",
        pageBuilder: (context, state) =>
            const CupertinoPage(child: SignupFirstScreen()),
      ),
      GoRoute(
        path: "/signUpSecond",
        pageBuilder: (context, state) =>
            const CupertinoPage(child: SignupSecondScreen()),
      ),
      GoRoute(
        path: "/signUpThird",
        pageBuilder: (context, state) =>
            const CupertinoPage(child: SignupThirdScreen()),
      ),
      GoRoute(
        path: "/app",
        pageBuilder: (context, state) =>
            const CupertinoPage(child: AppScreen()),
      ),
      GoRoute(
        path: "/createPost",
        pageBuilder: (context, state) =>
            CupertinoPage(child: CreatePostScreen()),
      ),
      GoRoute(
<<<<<<< HEAD
          path: "/profileEdit",
          pageBuilder: (context, state) =>
              CupertinoPage(child: EditProfileScreen())),
=======
          path: "/notification",
          pageBuilder: (context, state) =>
              const CupertinoPage(child: NotificationScreen())),
>>>>>>> feat/notification
    ],
  );
}
