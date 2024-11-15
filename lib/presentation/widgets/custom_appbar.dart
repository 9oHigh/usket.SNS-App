import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar(
      {super.key,
      required this.titleText,
      this.leading = false,
      this.leadingEvent});

  final String titleText;
  final bool leading;
  final VoidCallback? leadingEvent;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: leading
          ? GestureDetector(
              onTap: leadingEvent,
              child: Icon(Icons.arrow_back),
            )
          : null,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(titleText),
        ],
      ),
      titleTextStyle: const TextStyle(
          color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
    );
  }
}
