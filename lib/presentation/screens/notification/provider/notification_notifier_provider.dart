import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/presentation/screens/notification/provider/state/notification_notifier.dart';
import 'package:sns_app/presentation/screens/notification/provider/state/notification_state.dart';

final notificationNotifierProvder =
    AutoDisposeStateNotifierProvider<NotificationNotifier, NotificationState>((ref) => NotificationNotifier());
