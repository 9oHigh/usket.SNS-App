import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/core/manager/shared_preferences_manager.dart';
import 'package:sns_app/data/models/notification_model.dart';
import 'package:sns_app/presentation/screens/notification/provider/state/notification_state.dart';

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(NotificationState(notifications: [])) {
    initailize();
  }

  void initailize() async {
    SharedPreferenceManager()
        .setPref<int>(PrefsType.unReadNotificationCount, 0);
    fetchNotifications();
  }

  void fetchNotifications() async {
    final uid =
        SharedPreferenceManager().getPref<String>(PrefsType.userId) ?? "";

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .get();
      final notifications = snapshot.docs
          .map((doc) => NotificationModel.fromDocument(doc))
          .toList();
      state = state.copyWith(notifications: notifications);
      print('error: $notifications');
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}
