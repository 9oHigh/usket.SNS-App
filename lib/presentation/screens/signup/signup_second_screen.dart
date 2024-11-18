import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/constants/sizes.dart';
import 'package:sns_app/core/manager/alert_manager.dart';
import 'package:sns_app/presentation/widgets/custom_appbar.dart';

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
        appBar: const CustomAppbar(
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
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                              await FirebaseAuth.instance.currentUser?.reload();
                              if (FirebaseAuth
                                      .instance.currentUser?.emailVerified ??
                                  false) {
                                context.push('/signUpThird');
                              } else {
                                AlertManager.showCheckDialog(context, "인증 오류",
                                    "이메일 인증이 완료되지 않았습니다.\n이메일을 확인해주세요.");
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
