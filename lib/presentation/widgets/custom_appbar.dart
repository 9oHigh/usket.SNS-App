import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar(
      {super.key,
      required this.titleText,
      this.titleAlign = MainAxisAlignment.end,
      this.titleColor = Colors.white,
      this.leading = false,
      this.leadingColor = Colors.white,
      this.leadingEvent});

  final String titleText;
  final MainAxisAlignment titleAlign;
  final Color titleColor;
  final bool leading;
  final Color leadingColor;
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
              child: Icon(Icons.arrow_back, color: leadingColor),
            )
          : null,
      title: Row(
        mainAxisAlignment: titleAlign,
        children: [
          Text(titleText),
        ],
      ),
      titleTextStyle: TextStyle(
          color: titleColor, fontSize: 34, fontWeight: FontWeight.bold),
    );
  }
}
