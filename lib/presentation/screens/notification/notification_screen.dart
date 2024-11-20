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
    final notificationNotifier = ref.read(notificationNotifierProvder.notifier);
    final notificationState = ref.watch(notificationNotifierProvder);

    return StreamBuilder(
        stream: notificationState.notifications,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "알림이 없습니다.",
                style:
                    TextStyle(color: main_color, fontWeight: FontWeight.bold),
              ),
            );
          }
          final notifications = snapshot.data!;
          return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  title: Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    context.push('/postDetail', extra: notification.postId);
                  },
                );
              });
        });
  }
}
