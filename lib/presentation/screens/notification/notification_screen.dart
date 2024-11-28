import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/manager/shared_preferences_manager.dart';
import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/presentation/screens/notification/provider/notification_notifier_provider.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    SharedPreferenceManager()
        .setPref<int>(PrefsType.unReadNotificationCount, 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationNotifierProvder);
    final notificationNotifier = ref.read(notificationNotifierProvder.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '알림',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: main_color,
      ),
      body: notificationState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificationState.notifications.isEmpty
              ? const Center(
                  child: Text(
                    "알림이 없습니다.",
                    style: TextStyle(
                        color: main_color, fontWeight: FontWeight.w700),
                  ),
                )
              : ListView.builder(
                  itemCount: notificationState.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notificationState.notifications[index];
                    final icon = notification.type == "like"
                        ? Icons.favorite
                        : Icons.reply;
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GestureDetector(
                        onTap: () async {
                          final postSnapshot = await FirebaseFirestore.instance
                              .collection('posts')
                              .doc(notification.postId)
                              .get();

                          context.push('/postDetail',
                              extra: PostModel.fromDocument(postSnapshot));
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Icon(icon,
                                      color: icon == Icons.favorite
                                          ? Colors.red
                                          : Colors.black),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  notification.message,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Divider(
                              color: main_color,
                              thickness: 0.125,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
