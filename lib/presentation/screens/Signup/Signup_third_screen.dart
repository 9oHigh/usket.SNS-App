import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/constants/sizes.dart';
import 'package:sns_app/presentation/screens/signin/signin_screen.dart';
import 'package:sns_app/presentation/screens/signup/provider/signup_notifier_provider.dart';
import 'package:sns_app/presentation/widgets/label_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupThirdScreen extends ConsumerWidget {
  const SignupThirdScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupNotifier = ref.read(signupNotifierProvider.notifier);
    final signupState = ref.watch(signupNotifierProvider);
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
                            labelText: '이름',
                            errorText: signupState.nameError,
                            textfieldChanged: (value) =>
                                signupNotifier.updateName(value),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await signupNotifier.updateName(signupState.name);
                              if (signupState.nameError == '통과') {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .add({
                                    'nickname': signupState.name,
                                    'email': signupState.email,
                                    'post_ids': [],
                                    'followers': [],
                                    'followings': [],
                                  });
                                } catch (e) {
                                  print(e.toString());
                                }
                                GoRouter.of(context).go('/signin');
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
                  )),
            )
          ],
        ));
  }
}
