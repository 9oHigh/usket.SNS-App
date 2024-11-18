import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/presentation/screens/signup/provider/state/signup_notifier.dart';
import 'package:sns_app/presentation/screens/signup/provider/state/signup_state.dart';

final signupNotifierProvider =
    AutoDisposeStateNotifierProvider<SignupNotifier, SignupState>(
  (ref) => SignupNotifier(),
);
