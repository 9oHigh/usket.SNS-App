import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/presentation/screens/feed/provider/state/feed_notifier.dart';
import 'package:sns_app/presentation/screens/feed/provider/state/feed_state.dart';

final feedNotifierProvider = StateNotifierProvider<FeedNotifier, FeedState>(
  (ref) => FeedNotifier(),
);
