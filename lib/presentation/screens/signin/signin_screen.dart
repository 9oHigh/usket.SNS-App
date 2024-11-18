import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/constants/sizes.dart';
import 'package:sns_app/core/manager/alert_manager.dart';
import 'package:sns_app/presentation/screens/signin/provider/signin_notifier_provider.dart';
import 'package:sns_app/presentation/widgets/custom_appbar.dart';
import 'package:sns_app/presentation/widgets/gesture_button.dart';
import 'package:sns_app/presentation/widgets/label_textfield.dart';

class SigninScreen extends ConsumerWidget {
  const SigninScreen({super.key});

  bool _checkOptions(BuildContext context, String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      AlertManager.showCheckDialog(
          context, "로그인 오류", "이메일과 패스워드 모두 작성한 이후\n다시 시도해 주세요.");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sigininNotifier = ref.read(signinNotifierProvider.notifier);
    final signinState = ref.watch(signinNotifierProvider);

    return Scaffold(
        backgroundColor: main_color,
        resizeToAvoidBottomInset: false,
        appBar: const CustomAppbar(titleText: '로그인'),
        // MARK: - 앱 아이콘 같은것 상단에 하나 표시해두기
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
                      topLeft: Radius.circular(17),
                      topRight: Radius.circular(17)),
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(context) * 0.1,
                        vertical: getHeight(context) * 0.05),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            LabelTextfield(
                                labelText: '이메일',
                                textfieldChanged: (value) =>
                                    sigininNotifier.updateEmail(value)),
                            const SizedBox(height: 8),
                            LabelTextfield(
                                labelText: '비밀번호',
                                obscured: true,
                                textfieldChanged: (value) =>
                                    sigininNotifier.updatePassword(value)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            GestureButton(
                                height: getHeight(context) * 0.07,
                                text: '로그인',
                                textSize: 15.0,
                                onTapEvent: () async {
                                  if (_checkOptions(context, signinState.email,
                                      signinState.password)) {
                                    User? user = await sigininNotifier.signIn();
                                    if (user != null) {
                                      context.go('/app');
                                    } else {
                                      AlertManager.showCheckDialog(
                                          context,
                                          "로그인 오류",
                                          "이메일 혹은 패스워드가 옳바르지 않습니다. 다시 시도해 주세요.");
                                    }
                                  }
                                }),
                            SizedBox(height: getHeight(context) * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('계정이 없으십니까?',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                GestureDetector(
                                  onTap: () {
                                    context.push('/signupFirst');
                                  },
                                  child: const Text('회원가입',
                                      style: TextStyle(
                                          color: main_color,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            )
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
