import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/presentation/screens/feed/provider/state/feed_state.dart';

class FeedNotifier extends StateNotifier<FeedState> {
  FeedNotifier() : super(FeedState.initial());

  Future<void> loadFeed() async {
    print('loadFeed');
    state = state.copyWith(isLoading: true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();

      final posts =
          snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();

      state = state.copyWith(posts: posts, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      print('Error loading feed: $e');
    }
  }

  /// 게시물 좋아요 토글
  Future<void> toggleLike(PostModel post, String uid) async {
    final docRef =
        FirebaseFirestore.instance.collection('posts').doc(post.postId);
    bool isLiked = await _checkIfLiked(post, uid);

    try {
      await docRef.update({
        'likeCount': FieldValue.increment(isLiked ? -1 : 1),
      });

      final updatedPosts = state.posts.map((p) {
        if (p.postId == post.postId) {
          return p.copyWith(
            likeCount: p.likeCount + (isLiked ? -1 : 1),
          );
        }
        return p;
      }).toList();

      state = state.copyWith(posts: updatedPosts);
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  Future<bool> _checkIfLiked(PostModel post, String uid) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.postId)
        .get();
    final data = docSnapshot.data() as Map<String, dynamic>;
    final List<dynamic> likes = data['likes'] ?? [];
    return likes.contains(uid);
  }

  void updateBottomNavIndex(int index) {
    state = state.copyWith(bottomNavIndex: index);
  }
}
