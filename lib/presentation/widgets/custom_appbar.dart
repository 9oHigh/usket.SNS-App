import 'package:flutter/material.dart';
import 'package:sns_app/core/constants/colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar(
      {super.key,
      required this.titleText,
      this.titleAlign = MainAxisAlignment.end,
      this.titleColor = Colors.white,
      this.leading = false,
      this.leadingColor = Colors.white,
      this.actions,
      this.actionColor = main_color,
      this.leadingEvent});

  final String titleText;
  final MainAxisAlignment titleAlign;
  final Color titleColor;
  final bool leading;
  final Color leadingColor;
  final VoidCallback? leadingEvent;
  final List<Widget>? actions;
  final Color actionColor;

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
      actions: actions,
      centerTitle: titleAlign == MainAxisAlignment.center ? true : false,
      title: titleAlign == MainAxisAlignment.center
          ? Text(titleText)
          : Row(
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
