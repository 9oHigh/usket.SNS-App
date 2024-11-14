import 'package:sns_app/data/models/post_model.dart';

class FeedState {
  final List<PostModel> posts;
  final bool isLoading;
  final String? error;

  FeedState({
    required this.posts,
    required this.isLoading,
    this.error,
  });

  FeedState copyWith({
    List<PostModel>? posts,
    bool? isLoading,
    String? error,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  factory FeedState.initial() {
    return FeedState(posts: [], isLoading: false);
  }
}
