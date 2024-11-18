class SignupState {
  final String email;
  final String password;
  final String rePassword;
  final String name;
  final bool emailConfirm;
  final bool passwordConfirm;
  final bool rePasswordConfirm;
  final bool nameConfirm;
  final String errorMessage;

  SignupState({
    this.email = '',
    this.password = '',
    this.rePassword = '',
    this.name = '',
    this.emailConfirm = false,
    this.passwordConfirm = false,
    this.rePasswordConfirm = false,
    this.nameConfirm = false,
    this.errorMessage = '',
  });

  SignupState copyWith({
    String? email,
    String? password,
    String? rePassword,
    String? name,
    bool? emailConfirm,
    bool? passwordConfirm,
    bool? rePasswordConfirm,
    bool? nameConfirm,
    String? errorMessage,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      rePassword: rePassword ?? this.rePassword,
      name: name ?? this.name,
      emailConfirm: emailConfirm ?? this.emailConfirm,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      rePasswordConfirm: rePasswordConfirm ?? this.rePasswordConfirm,
      nameConfirm: nameConfirm ?? this.nameConfirm,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
