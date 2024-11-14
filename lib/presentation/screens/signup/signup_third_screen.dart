import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/constants/sizes.dart';
import 'package:sns_app/presentation/screens/Signin/Signin_screen.dart';
import 'package:sns_app/presentation/widgets/label_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupThirdScreen extends StatefulWidget {
  const SignupThirdScreen({super.key});

  @override
  State<SignupThirdScreen> createState() => _SignupThirdScreenState();
}

class _SignupThirdScreenState extends State<SignupThirdScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  String? _nameError;

  bool _nameDuplicated = false;

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
              Text('Sign Up'),
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
                        const Text('Sign Up',
                            style: TextStyle(
                                color: main_color,
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            LabelTextfield(
                              controller: _nameController,
                              labelText: '이름',
                              errorText: _nameError,
                              textfieldChanged: (value) {
                                _validateName(value);
                                _isNameDuplicate(value);
                                setState(() {
                                  _nameController.text = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                _validateName(_nameController.text);
                                setState(() {});
                                if (_nameError == null) {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .add({
                                      'nickname': _nameController.text,
                                      'email': FirebaseAuth
                                          .instance.currentUser!.email,
                                      'post_ids': [],
                                      'followers': [],
                                      'followings': [],
                                    });
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SigninScreen()));
                                }
                              },
                              child: Container(
                                height: getHeight(context) * 0.07,
                                decoration: const BoxDecoration(
                                    color: main_color,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(17))),
                                child: const Center(
                                  child: Text('NEXT',
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

  // 이메일 중복 검사
  Future<void> _isNameDuplicate(String name) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();
    _nameDuplicated = querySnapshot.docs.isNotEmpty;
  }

  // 이메일 유효성 검사 함수
  void _validateName(String name) {
    if (name.isEmpty) {
      _nameError = '닉네임을 입력하세요';
    } else if (_nameDuplicated) {
      _nameError = '이미 사용 중인 닉네임입니다';
    } else if (name.length < 2) {
      _nameError = '최소 2자리 이상의 닉네임을 입력하세요';
    } else {
      _nameError = null;
    }
  }
}
