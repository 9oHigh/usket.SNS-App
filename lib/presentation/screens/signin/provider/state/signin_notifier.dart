import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/core/di/injector.dart';
import 'package:sns_app/core/manager/shared_preferences_manager.dart';
import 'package:sns_app/domain/usecases/signin/signin_usecase.dart';
import 'package:sns_app/presentation/screens/signin/provider/state/Signin_state.dart';

class SigninNotifier extends StateNotifier<SigninState> {
  final SigninUsecase _signInUsecase = injector.get<SigninUsecase>();

  SigninNotifier() : super(SigninState());

  Future<void> updateEmail(String email) async {
    state = state.copyWith(email: email);
  }

  Future<void> updatePassword(String password) async {
    state = state.copyWith(password: password);
  }

  Future<User?> signIn() async {
    final String email = state.email;
    final String password = state.password;
    try {
      User? user = await _signInUsecase.signIn(email, password);
      String userId = user!.uid;
      SharedPreferenceManager().setPref<String>(PrefsType.userId, userId);
      SharedPreferenceManager().setPref<bool>(PrefsType.isLoggedIn, true);
      return user;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return null;
    }
  }
}
