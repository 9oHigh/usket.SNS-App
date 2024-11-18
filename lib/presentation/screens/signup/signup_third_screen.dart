import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/constants/sizes.dart';
import 'package:sns_app/core/manager/alert_manager.dart';
import 'package:sns_app/presentation/screens/signup/provider/signup_notifier_provider.dart';
import 'package:sns_app/presentation/widgets/label_textfield.dart';

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
            children: [Text('회원가입')],
          ),
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
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
                        vertical: getHeight(context) * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('사용하실 닉네임을 입력해주세요.',
                            style: TextStyle(
                                color: main_color,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            LabelTextfield(
                              labelText: '닉네임',
                              textfieldChanged: (value) =>
                                  signupNotifier.updateName(value),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await signupNotifier
                                    .updateName(signupState.name);
                                if (signupState.nameConfirm) {
                                  await signupNotifier.addUserToFirestore();
                                  AlertManager.showCheckDialog(
                                    context,
                                    "회원가입 완료",
                                    "회원가입이 완료되었습니다.\n로그인 화면으로 이동합니다.",
                                    callback: () => context.go('/signin'),
                                  );
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
                                  child: Text('완료',
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
