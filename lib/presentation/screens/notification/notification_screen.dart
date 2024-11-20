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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!notificationState.isLoading) {
        notificationNotifier.initailize();
      }
    });

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
                  },
                ),
    );
  }
}
