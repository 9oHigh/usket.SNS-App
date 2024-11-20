import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/core/manager/shared_preferences_manager.dart';
import 'package:sns_app/data/models/notification_model.dart';
import 'package:sns_app/presentation/screens/notification/provider/state/notification_state.dart';

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier()
      : super(NotificationState(notifications: const Stream.empty())) {
    initailize();
  }

  void initailize() async {
    Stream<List<NotificationModel>> notifications = _fetchNotifications();
    state = state.copyWith(notifications: notifications);
  }

  Stream<List<NotificationModel>> _fetchNotifications() {
    final uid =
        SharedPreferenceManager().getPref<String>(PrefsType.userId) ?? "";
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromDocument(doc))
            .toList());
  }
}
