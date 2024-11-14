import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/constants/sizes.dart';
import 'package:sns_app/presentation/screens/Signup/Signup_second_screen.dart';
import 'package:sns_app/presentation/widgets/label_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupFirstScreen extends StatefulWidget {
  const SignupFirstScreen({super.key});

  @override
  State<SignupFirstScreen> createState() => _SignupFirstScreenState();
}

class _SignupFirstScreenState extends State<SignupFirstScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _rePasswordError;

  bool _emailDuplicated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: main_color,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('회원가입'),
            ],
          ),
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: getWidth(context),
              height: getHeight(context) * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(context) * 0.1,
                      vertical: getHeight(context) * 0.05),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('회원가입',
                            style: TextStyle(
                                color: main_color,
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            LabelTextfield(
                              controller: _emailController,
                              labelText: '이메일',
                              errorText: _emailError,
                              textfieldChanged: (value) {
                                _validateEmail(value);
                                _isEmailDuplicate(value);
                                setState(() {
                                  _emailController.text = value;
                                });
                              },
                            ),
                            LabelTextfield(
                                controller: _passwordController,
                                labelText: '비밀번호',
                                errorText: _passwordError,
                                textfieldChanged: (value) {
                                  _validatePassword(value);
                                  setState(() {
                                    _passwordController.text = value;
                                  });
                                },
                                obscured: true),
                            LabelTextfield(
                                controller: _rePasswordController,
                                labelText: '비밀번호 재확인',
                                errorText: _rePasswordError,
                                textfieldChanged: (value) {
                                  _validateConfirmPassword(value);
                                  setState(() {
                                    _rePasswordController.text = value;
                                  });
                                },
                                obscured: true)
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                _validateEmail(_emailController.text);
                                _validatePassword(_passwordController.text);
                                _validateConfirmPassword(
                                    _rePasswordController.text);
                                setState(() {});
                                if (_emailError == null &&
                                    _passwordError == null &&
                                    _rePasswordError == null) {
                                  // TODO: 함수로 옮기기 (회원가입)
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: _emailController.text,
                                          password: _passwordController.text);
                                  await FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignupSecondScreen()));
                                }
                              },
                              child: Container(
                                height: getHeight(context) * 0.07,
                                decoration: const BoxDecoration(
                                    color: main_color,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(17))),
                                child: const Center(
                                  child: Text('다음',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
            )
          ],
        ));
  }

  // 이메일 유효성 검사 함수
  bool isValidEmail(String email) {
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  // 이메일 중복 검사
  Future<void> _isEmailDuplicate(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    _emailDuplicated = querySnapshot.docs.isNotEmpty;
  }

  // 이메일 유효성 검사 함수
  void _validateEmail(String email) {
    if (email.isEmpty) {
      _emailError = '이메일을 입력하세요';
    } else if (!isValidEmail(email)) {
      _emailError = '이메일 형식에 맞추어 입력하세요';
    } else if (_emailDuplicated) {
      _emailError = '이미 가입된 이메일입니다';
    } else {
      _emailError = null;
    }
  }

  // 비밀번호 유효성 검사 함수
  void _validatePassword(String password) {
    if (password.isEmpty) {
      _passwordError = '비밀번호를 입력하세요';
    } else if (password.length < 8) {
      _passwordError = '최소 8자리 이상의 비밀번호를 입력하세요';
    } else {
      _passwordError = null;
    }
  }

  // 비밀번호 확인 유효성 검사 함수
  void _validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) {
      _rePasswordError = '재확인 비밀번호를 입력하세요';
    } else if (confirmPassword != _passwordController.text) {
      _rePasswordError = '비밀번호가 일치하지 않습니다';
    } else {
      _rePasswordError = null;
    }
  }
}
