import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/presentation/screens/create_post/provider/state/create_post_notifier.dart';
import 'state/create_post_state.dart';

final createPostNotifierProvider =
    StateNotifierProvider<CreatePostNotifier, CreatePostState>(
  (ref) => CreatePostNotifier(),
);
