import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/presentation/screens/feed/provider/state/feed_state.dart';

class FeedNotifier extends StateNotifier<FeedState> {
  FeedNotifier() : super(FeedState.initial());

  Future<void> loadFeed() async {
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
    }
  }

  Future<void> toggleLike(PostModel post, String uid) async {
    final docRef =
        FirebaseFirestore.instance.collection('posts').doc(post.postId);
    bool isLiked = post.likes.contains(uid);

    await docRef.update({
      'likes': isLiked
          ? FieldValue.arrayRemove([uid])
          : FieldValue.arrayUnion([uid]),
      'likesCount': FieldValue.increment(isLiked ? -1 : 1),
    });

    final updatedPosts = state.posts.map((p) {
      if (p.postId == post.postId) {
        return p.copyWith(
          likes: isLiked
              ? (List<String>.from(p.likes)..remove(uid))
              : (List<String>.from(p.likes)..add(uid)),
          likesCount: p.likesCount + (isLiked ? -1 : 1),
        );
      }
      return p;
    }).toList();

    state = state.copyWith(posts: updatedPosts);
  }

  void updateBottomNavIndex(int index) {
    state = state.copyWith(bottomNavIndex: index);
  }
}
