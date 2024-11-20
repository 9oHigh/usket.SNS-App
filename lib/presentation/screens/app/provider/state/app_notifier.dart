import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/core/manager/shared_preferences_manager.dart';
import 'package:sns_app/presentation/screens/app/provider/state/app_state.dart';

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier() : super(AppState()) {
    updateNotificationCount();
    litenNotifications();
  }

  void setErrorMessage(String message) {
    state = state.copyWith(errorMessage: message);
  }

  void updateBottomNavIndex(int index) {
    state = state.copyWith(bottomNavIndex: index);
  }

  void updateNotificationCount() async {
    final unReadNotifiactionCount = SharedPreferenceManager()
            .getPref<int>(PrefsType.unReadNotificationCount) ??
        0;
    state = state.copyWith(notificationCount: unReadNotifiactionCount);
  }

  Future<void> litenNotifications() async {
    /*
    Token 확인용 코드
    final token = await FirebaseMessaging.instance.getToken();
     */
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        FlutterLocalNotificationsPlugin().show(
            notification.hashCode,
            notification.title,
            notification.body,
            const NotificationDetails(
                android: AndroidNotificationDetails(
              'high_importance_channel',
              'high_importance_notification',
              importance: Importance.max,
            )));
        int count = state.notificationCount;
        state = state.copyWith(notificationCount: count + 1);
        SharedPreferenceManager()
            .setPref<int>(PrefsType.unReadNotificationCount, count + 1);
      }
    });
  }
}
