import 'package:sns_app/data/models/post_model.dart';

class FeedState {
  final List<PostModel> posts;
  final bool isLoading;
  final String? error;
  final int bottomNavIndex;

  FeedState({
    required this.posts,
    required this.isLoading,
    this.error,
    this.bottomNavIndex = 0,
  });

  FeedState copyWith({
    List<PostModel>? posts,
    bool? isLoading,
    String? error,
    int? bottomNavIndex,
  }) {
    return FeedState(
        posts: posts ?? this.posts,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex);
  }

  factory FeedState.initial() {
    return FeedState(
      posts: [],
      isLoading: false,
      bottomNavIndex: 0,
    );
  }
}
