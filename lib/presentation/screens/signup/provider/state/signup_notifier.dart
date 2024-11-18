import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/core/di/injector.dart';
import 'package:sns_app/domain/usecases/signup/signup_usecase.dart';
import 'package:sns_app/presentation/screens/signup/provider/state/signup_state.dart';

class SignupNotifier extends StateNotifier<SignupState> {
  final SignupUsecase _signupUsecase = injector.get<SignupUsecase>();

  SignupNotifier() : super(SignupState());

  Future<void> updateEmail(String email) async {
    await _validateEmail(email);
    state = state.copyWith(email: email);
  }

  Future<void> updatePassword(String password) async {
    await _validatePassword(password);
    state = state.copyWith(password: password);
  }

  Future<void> updateRePassword(String password, String rePassword) async {
    await _validateRePassword(password, rePassword);
    state = state.copyWith(rePassword: rePassword);
  }

  Future<void> updateName(String name) async {
    await _validateName(name);
    state = state.copyWith(name: name);
  }

  // 이메일 형식 검사 함수
  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  // 이메일 중복 검사 함수
  Future<bool> _isDuplicatedEmail(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  // 이메일 유효성 검사 함수
  Future<void> _validateEmail(String email) async {
    String? emailError;
    bool emailConfirm = false;

    if (email.isEmpty) {
      emailError = '이메일을 입력하세요';
    } else if (!_isValidEmail(email)) {
      emailError = '이메일 형식에 맞추어 입력하세요';
    } else if (await _isDuplicatedEmail(email)) {
      emailError = '이미 가입된 이메일입니다';
    } else {
      emailError = "";
    }

    if (emailError.isEmpty) emailConfirm = true;

    state =
        state.copyWith(emailConfirm: emailConfirm, errorMessage: emailError);
  }

  // 비밀번호 유효성 검사 함수
  Future<void> _validatePassword(String password) async {
    String? passwordError;
    bool passwordConfirm = false;

    if (password.isEmpty) {
      passwordError = '비밀번호를 입력하세요';
    } else if (password.length < 8) {
      passwordError = '최소 8자리 이상의 비밀번호를 입력하세요';
    } else {
      passwordError = "";
    }

    if (passwordError.isEmpty) passwordConfirm = true;

    state = state.copyWith(
        passwordConfirm: passwordConfirm, errorMessage: passwordError);
  }

  // 비밀번호 확인 유효성 검사 함수
  Future<void> _validateRePassword(String password, String rePassword) async {
    String? rePasswordError;
    bool rePasswordConfirm = false;

    if (rePassword.isEmpty) {
      rePasswordError = '재확인 비밀번호를 입력하세요';
    } else if (password != rePassword) {
      rePasswordError = '비밀번호가 일치하지 않습니다';
    } else {
      rePasswordError = "";
    }

    if (rePasswordError.isEmpty) rePasswordConfirm = true;

    state = state.copyWith(
        rePasswordConfirm: rePasswordConfirm, errorMessage: rePasswordError);
  }

  // 닉네임 중복 검사
  Future<bool> _isNameDuplicate(String nickname) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('nickname', isEqualTo: nickname)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  // 닉네임 유효성 검사 함수
  Future<void> _validateName(String nickname) async {
    String? nameError;
    bool nameConfirm = false;

    if (nickname.isEmpty) {
      nameError = '닉네임을 입력하세요';
    } else if (await _isNameDuplicate(nickname)) {
      nameError = '이미 사용 중인 닉네임입니다';
    } else if (nickname.length < 2) {
      nameError = '최소 2자리 이상의 닉네임을 입력하세요';
    } else {
      nameError = "";
    }

    if (nameError.isEmpty) nameConfirm = true;
    state = state.copyWith(nameConfirm: nameConfirm, errorMessage: nameError);
  }

  Future<void> createUserWithEmailAndPassword() async {
    final String email = state.email;
    final String password = state.password;
    try {
      await _signupUsecase.createUserWithEmailAndPassword(email, password);
      await _signupUsecase.sendEmailVerification();
    } catch (e) {
      state = state.copyWith(); // MARK: - Error 표시하기
    }
  }

  Future<void> addUserToFirestore() async {
    final String email = state.email;
    final String nickname = state.name;
    try {
      await _signupUsecase.addUserToFirestore(nickname, email);
    } catch (e) {
      state = state.copyWith(); // MARK: - Error 표시하기
    }
  }
}
