import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/presentation/screens/notification/provider/notification_notifier_provider.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
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
                        onTap: () {
                          context.push('/postDetail',
                              extra: notification.postId);
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
