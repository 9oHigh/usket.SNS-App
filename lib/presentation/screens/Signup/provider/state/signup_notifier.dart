import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/presentation/screens/signup/provider/state/signup_state.dart';

class SignupNotifier extends StateNotifier<SignupState> {
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
    String? _emailError;

    if (email.isEmpty) {
      _emailError = '이메일을 입력하세요';
    } else if (!_isValidEmail(email)) {
      _emailError = '이메일 형식에 맞추어 입력하세요';
    } else if (await _isDuplicatedEmail(email)) {
      _emailError = '이미 가입된 이메일입니다';
    } else {
      _emailError = '통과';
    }

    state = state.copyWith(emailError: _emailError);
  }

  // 비밀번호 유효성 검사 함수
  Future<void> _validatePassword(String password) async {
    String? _passwordError;

    if (password.isEmpty) {
      _passwordError = '비밀번호를 입력하세요';
    } else if (password.length < 8) {
      _passwordError = '최소 8자리 이상의 비밀번호를 입력하세요';
    } else {
      _passwordError = '통과';
    }

    state = state.copyWith(passwordError: _passwordError);
  }

  // 비밀번호 확인 유효성 검사 함수
  Future<void> _validateRePassword(String password, String rePassword) async {
    String? _rePasswordError;

    if (rePassword.isEmpty) {
      _rePasswordError = '재확인 비밀번호를 입력하세요';
    } else if (password != rePassword) {
      _rePasswordError = '비밀번호가 일치하지 않습니다';
    } else {
      _rePasswordError = '통과';
    }

    state = state.copyWith(rePasswordError: _rePasswordError);
  }

  // 이메일 중복 검사
  Future<bool> _isNameDuplicate(String name) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  // 이메일 유효성 검사 함수
  Future<void> _validateName(String name) async {
    String? _nameError;

    if (name.isEmpty) {
      _nameError = '닉네임을 입력하세요';
    } else if (await _isNameDuplicate(name)) {
      _nameError = '이미 사용 중인 닉네임입니다';
    } else if (name.length < 2) {
      _nameError = '최소 2자리 이상의 닉네임을 입력하세요';
    } else {
      _nameError = '통과';
    }

    state = state.copyWith(nameError: _nameError);
  }
}
