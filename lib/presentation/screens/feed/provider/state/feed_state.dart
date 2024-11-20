import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns_app/data/models/post_model.dart';

class FeedState {
  final List<PostModel> posts;
  final bool isLoading;
  final String? error;
  final DocumentSnapshot? lastDocument;

  FeedState({
    this.posts = const [],
    required this.isLoading,
    this.error,
    this.lastDocument,
  });

  FeedState copyWith({
    List<PostModel>? posts,
    bool? isLoading,
    String? error,
    DocumentSnapshot? lastDocument,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: this.error,
      lastDocument: this.lastDocument,
    );
  }

  factory FeedState.initial() {
    return FeedState(
      posts: [],
      isLoading: false,
    );
  }
}
