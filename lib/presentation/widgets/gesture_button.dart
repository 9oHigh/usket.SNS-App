import 'package:flutter/material.dart';
import 'package:sns_app/core/constants/colors.dart';

class GestureButton extends StatelessWidget {
  GestureButton(
      {super.key,
      required this.width,
      required this.height,
      required this.text,
      required this.textSize,
      this.onTapEvent});

  final width;
  final height;
  final text;
  final textSize;
  GestureTapCallback? onTapEvent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapEvent,
      child: Container(
        width: width,
        height: height,
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