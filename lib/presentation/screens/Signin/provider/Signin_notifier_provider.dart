import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/presentation/screens/signin/provider/state/Signin_notifier.dart';
import 'package:sns_app/presentation/screens/signin/provider/state/Signin_state.dart';

final signinNotifierProvider =
    StateNotifierProvider<SigninNotifier, SigninState>(
  (ref) => SigninNotifier(),
);
