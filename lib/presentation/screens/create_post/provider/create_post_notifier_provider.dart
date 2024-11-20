import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'state/create_post_notifier.dart';
import 'state/create_post_state.dart';

final createPostNotifierProvider =
    StateNotifierProvider<CreatePostNotifier, CreatePostState>(
  (ref) => CreatePostNotifier(),
);
