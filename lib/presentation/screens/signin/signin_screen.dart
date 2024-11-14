import 'package:flutter/material.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/constants/sizes.dart';
import 'package:sns_app/presentation/screens/signup/signup_first_screen.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
              Text('로그인'),
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
                    topLeft: Radius.circular(17),
                    topRight: Radius.circular(17)),
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(context) * 0.1,
                      vertical: getHeight(context) * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('로그인',
                          style: TextStyle(
                              color: main_color,
                              fontSize: 34,
                              fontWeight: FontWeight.bold)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('이메일'),
                              SizedBox(
                                height: getHeight(context) * 0.07,
                                child: const TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: getHeight(context) * 0.01),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('비밀번호'),
                              SizedBox(
                                height: getHeight(context) * 0.07,
                                child: const TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: getHeight(context) * 0.01),
                          const Text('비밀번호 찾기',
                              style: TextStyle(
                                  color: main_color,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: getHeight(context) * 0.07,
                            decoration: const BoxDecoration(
                                color: main_color,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(17))),
                            child: const Center(
                              child: Text('로그인',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            height: getHeight(context) * 0.01,
                          ),
                          const Text('계정이 없으십니까?',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupFirstScreen()));
                            },
                            child: const Text('회원가입',
                                style: TextStyle(
                                    color: main_color,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
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
