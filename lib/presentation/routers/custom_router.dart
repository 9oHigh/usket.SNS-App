import 'package:go_router/go_router.dart';
import 'package:sns_app/presentation/screens/signin/signin_screen.dart';
import 'package:sns_app/presentation/screens/create_post/create_post_screen.dart';
import 'package:sns_app/presentation/screens/feed/feed_screen.dart';
import 'package:sns_app/presentation/screens/signup/Signup_first_screen.dart';
import 'package:sns_app/presentation/screens/signup/Signup_second_screen.dart';
import 'package:sns_app/presentation/screens/signup/Signup_third_screen.dart';

class CustomRouter {
  static GoRouter router = GoRouter(initialLocation: "/signin", routes: [
    GoRoute(path: "/signin", builder: (_, __) => SigninScreen()),
    GoRoute(path: "/signUpFirst", builder: (_, __) => SignupFirstScreen()),
    GoRoute(
        path: "/signUpSecond", builder: (_, __) => const SignupSecondScreen()),
    GoRoute(
        path: "/signUpThird", builder: (_, __) => const SignupThirdScreen()),
    GoRoute(path: "/feed", builder: (_, __) => FeedScreen()),
    GoRoute(path: "/createPost", builder: (_, __) => CreatePostScreen()),
  ]);
}
