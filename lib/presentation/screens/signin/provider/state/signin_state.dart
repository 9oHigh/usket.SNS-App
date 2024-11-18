class SigninState {
  final String email;
  final String password;
  final String errorMessage;

  SigninState({
    this.email = '',
    this.password = '',
    this.errorMessage = '',
  });

  SigninState copyWith({
    String? email,
    String? password,
    String? errorMessage,
  }) {
    return SigninState(
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
