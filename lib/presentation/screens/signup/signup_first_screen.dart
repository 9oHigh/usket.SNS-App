import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/constants/sizes.dart';
import 'package:sns_app/presentation/screens/signup/provider/signup_notifier_provider.dart';
import 'package:sns_app/presentation/widgets/custom_appbar.dart';
import 'package:sns_app/presentation/widgets/label_textfield.dart';

class SignupFirstScreen extends ConsumerWidget {
  const SignupFirstScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupNotifier = ref.read(signupNotifierProvider.notifier);
    final signupState = ref.watch(signupNotifierProvider);
    return Scaffold(
        backgroundColor: main_color,
        resizeToAvoidBottomInset: false,
        // Custome Appbar 사용
        appBar: CustomAppbar(
          titleText: '회원가입',
          leading: true,
          leadingEvent: () async {
            if (FirebaseAuth.instance.currentUser != null) {
              await FirebaseAuth.instance.currentUser!.delete();
            }
            context.pop();
          },
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Panel 형식으로 UI 구현
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          LabelTextfield(
                            labelText: '이메일',
                            errorText: signupState.emailError,
                            textfieldChanged: (value) =>
                                signupNotifier.updateEmail(value),
                          ),
                          LabelTextfield(
                              labelText: '비밀번호',
                              errorText: signupState.passwordError,
                              textfieldChanged: (value) =>
                                  signupNotifier.updatePassword(value),
                              obscured: true),
                          LabelTextfield(
                              labelText: '비밀번호 재확인',
                              errorText: signupState.rePasswordError,
                              textfieldChanged: (value) =>
                                  signupNotifier.updateRePassword(
                                      signupState.password, value),
                              obscured: true)
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await signupNotifier
                                  .updateEmail(signupState.email);
                              await signupNotifier
                                  .updatePassword(signupState.password);
                              await signupNotifier.updateRePassword(
                                  signupState.password, signupState.rePassword);

                              if (signupState.emailError == '통과' &&
                                  signupState.passwordError == '통과' &&
                                  signupState.rePasswordError == '통과') {
                                // TODO: 함수로 옮기기 (회원가입)
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: signupState.email,
                                        password: signupState.password);
                                await FirebaseAuth.instance.currentUser!
                                    .sendEmailVerification();
                                context.push('/signUpSecond');
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
