import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/constants/sizes.dart';
import 'package:sns_app/core/manager/alert_manager.dart';
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
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
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
                      vertical: getHeight(context) * 0.05,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            LabelTextfield(
                              labelText: '이메일',
                              textfieldChanged: (value) =>
                                  signupNotifier.updateEmail(value),
                            ),
                            const SizedBox(height: 8),
                            LabelTextfield(
                                labelText: '비밀번호',
                                textfieldChanged: (value) =>
                                    signupNotifier.updatePassword(value),
                                obscured: true),
                            const SizedBox(height: 8),
                            LabelTextfield(
                                labelText: '비밀번호 재확인',
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
                                    signupState.password,
                                    signupState.rePassword);

                                if (signupState.emailConfirm &&
                                    signupState.passwordConfirm &&
                                    signupState.rePasswordConfirm) {
                                  signupNotifier
                                      .createUserWithEmailAndPassword();
                                  context.push('/signUpSecond');
                                } else {
                                  AlertManager.showCheckDialog(context, "오류 안내",
                                      signupState.errorMessage);
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
          ),
        ));
  }
}
