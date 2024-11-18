class SigninState {
  final String email;
  final String password;
  final String errorMessage;
  final bool autoLogin;

  SigninState({
    this.email = '',
    this.password = '',
    this.errorMessage = '',
    this.autoLogin = false,
  });

  SigninState copyWith({
    String? email,
    String? password,
    String? errorMessage,
    bool? autoLogin,
  }) {
    return SigninState(
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      autoLogin: autoLogin ?? this.autoLogin,
    );
  }
}
