import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/presentation/screens/signin/provider/state/Signin_state.dart';

class SigninNotifier extends StateNotifier<SigninState> {
  SigninNotifier() : super(SigninState());

  Future<void> updateEmail(String email) async {
    state = state.copyWith(email: email);
  }

  Future<void> updatePassword(String password) async {
    state = state.copyWith(password: password);
  }
}
