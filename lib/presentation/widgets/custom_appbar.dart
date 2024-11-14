import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key, required this.titleText});

  final titleText;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('회원가입'),
        ],
      ),
      titleTextStyle: const TextStyle(
          color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
    );
  }
}
