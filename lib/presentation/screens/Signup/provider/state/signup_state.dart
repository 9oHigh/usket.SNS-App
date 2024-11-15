class SignupState {
  final String email;
  final String password;
  final String rePassword;
  final String name;
  final String emailError;
  final String passwordError;
  final String rePasswordError;
  final String nameError;

  SignupState({
    this.email = '',
    this.password = '',
    this.rePassword = '',
    this.name = '',
    this.emailError = '',
    this.passwordError = '',
    this.rePasswordError = '',
    this.nameError = '',
  });

  SignupState copyWith({
    String? email,
    String? password,
    String? rePassword,
    String? name,
    String? emailError,
    String? passwordError,
    String? rePasswordError,
    String? nameError,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      rePassword: rePassword ?? this.rePassword,
      name: name ?? this.name,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      rePasswordError: rePasswordError ?? this.rePasswordError,
      nameError: nameError ?? this.nameError,
    );
  }
}
