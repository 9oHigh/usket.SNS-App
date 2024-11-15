import 'package:flutter/material.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/constants/sizes.dart';

class GestureButton extends StatelessWidget {
  GestureButton(
      {super.key,
      this.width,
      this.height,
      required this.text,
      required this.textSize,
      this.onTapEvent});

  final double? width;
  final double? height;
  final text;
  final textSize;
  GestureTapCallback? onTapEvent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapEvent,
      child: Container(
        width: width ?? getWidth(context),
        height: height ?? getHeight(context),
        decoration: BoxDecoration(
          color: main_color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
            child: Text(text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: textSize,
                    fontWeight: FontWeight.bold))),
      ),
    );
  }
}
