import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/presentation/screens/signin/provider/state/signin_notifier.dart';
import 'package:sns_app/presentation/screens/signin/provider/state/signin_state.dart';

final signinNotifierProvider =
    AutoDisposeStateNotifierProvider<SigninNotifier, SigninState>(
  (ref) => SigninNotifier(),
);
