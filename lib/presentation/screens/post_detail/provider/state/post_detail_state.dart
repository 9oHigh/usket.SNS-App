import 'package:sns_app/data/models/comment_model.dart';
import 'package:sns_app/data/models/post_model.dart';

class PostDetailState {
  final PostModel? post;
  final List<CommentModel> comments;
  final bool isLoading;
  final String? error;

  PostDetailState({
    this.post,
    this.comments = const [],
    this.isLoading = false,
    this.error,
  });

  PostDetailState copyWith({
    PostModel? post,
    List<CommentModel>? comments,
    bool? isLoading,
    String? error,
  }) {
    return PostDetailState(
      post: post ?? this.post,
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
