import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
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

  static void showNotificationPermissionAlert(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: const Column(
              children: [Text("알림 권한 안내")],
            ),
            //
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "게시물 좋아요 및 댓글 알림을 위한\n알림 권한이 필요합니다.",
                  textAlign: TextAlign.center,
                )
              ],
            ),
            actions: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: main_color),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "취소",
                          style: TextStyle(color: Colors.white),
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: main_color),
                      onPressed: () async {
                        bool settingsOpened = await openAppSettings();
                        if (settingsOpened) {
                          BasicMessageChannel<String?> lifecycleChannel =
                              SystemChannels.lifecycle;
                          lifecycleChannel
                              .setMessageHandler((String? msg) async {
                            if (msg!.contains("resumed")) {
                              PermissionStatus changedStatus =
                                  await Permission.notification.status;
                              if (changedStatus == PermissionStatus.granted) {
                                Navigator.pop(context);
                              } else {
                                Navigator.pop(context);
                                AlertManager.showNotificationPermissionAlert(
                                    context);
                              }
                            }
                            return '';
                          });
                        }
                      },
                      child: const Text("확인",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
