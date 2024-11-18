import 'package:flutter/material.dart';
import 'package:sns_app/core/constants/colors.dart';

class AlertManager {
  static void showCheckDialog(
      BuildContext context, String title, String content,
      {VoidCallback? callback}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Column(
              children: [Text(title)],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  content,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: main_color),
                  onPressed: () {
                    if (callback != null) {
                      callback();
                    }
                    Navigator.pop(context);
                  },
                  child:
                      const Text("확인", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          );
        });
  }
}
