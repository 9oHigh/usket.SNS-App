import 'package:sns_app/data/models/user_model.dart';

class SigninState {
  final UserModel? user;
  final String email;
  final String password;
  final String errorMessage;
  final bool autoLogin;

  SigninState({
    this.user,
    this.email = '',
    this.password = '',
    this.errorMessage = '',
    this.autoLogin = false,
  });

  SigninState copyWith({
    UserModel? user,
    String? email,
    String? password,
    String? errorMessage,
    bool? autoLogin,
  }) {
    return SigninState(
      user: user,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      autoLogin: autoLogin ?? this.autoLogin,
    );
  }
}
