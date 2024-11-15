import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/core/constants/colors.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        GoRouter.of(context).push('/createPost');
      },
      backgroundColor: main_color,
      shape: const CircleBorder(),
      child: const Icon(
        color: Colors.white,
        Icons.add,
      ),
    );
  }
}
