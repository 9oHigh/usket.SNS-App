import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/constants/sizes.dart';
import 'package:sns_app/presentation/screens/signup/signup_third_screen.dart';
import 'package:sns_app/presentation/widgets/custom_appbar.dart';
import 'package:sns_app/presentation/widgets/gesture_button.dart';

class SignupSecondScreen extends StatefulWidget {
  const SignupSecondScreen({super.key});

  @override
  State<SignupSecondScreen> createState() => _SignupSecondScreenState();
}

class _SignupSecondScreenState extends State<SignupSecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: main_color,
        resizeToAvoidBottomInset: false,
        appBar: CustomAppbar(
          titleText: '회원가입',
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('회원가입',
                          style: TextStyle(
                              color: main_color,
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('E-MAIL이 전송되었습니다.',
                              style: TextStyle(
                                  color: main_color,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                          Text('E-MAIL을 확인해 이메일 인증을 진행해주세요.',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await FirebaseAuth.instance.currentUser!.reload();
                              if (FirebaseAuth
                                  .instance.currentUser!.emailVerified) {
                                GoRouter.of(context).push('/signUpThird');
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (dialogContext) {
                                      return AlertDialog(
                                        content: const Text('이메일 인증이 되지않았습니다.',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        actions: [
                                          GestureButton(
                                            width: getWidth(context) * 0.15,
                                            height: getHeight(context) * 0.05,
                                            text: "확인",
                                            textSize: 15.0,
                                            onTapEvent: () {
                                              Navigator.pop(dialogContext);
                                            },
                                          )
                                        ],
                                      );
                                    });
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
                  )),
            )
          ],
        ));
  }
}
