import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/presentation/screens/feed/provider/state/feed_state.dart';

class FeedNotifier extends StateNotifier<FeedState> {
  FeedNotifier() : super(FeedState.initial());

  Future<void> loadFeed() async {
    state = state.copyWith(isLoading: true);
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('posts').get();
      final posts = snapshot.docs
          .map((doc) =>
              PostModel.fromDocument(doc.data() as Map<String, dynamic>))
          .toList();

      state = state.copyWith(posts: posts, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleLike(PostModel post, String uid) async {
    final docRef =
        FirebaseFirestore.instance.collection('posts').doc(post.postId);

    if (post.likes.contains(uid)) {
      await docRef.update({
        'likes': FieldValue.arrayRemove([uid]),
        'likesCount': FieldValue.increment(-1),
      });
    } else {
      await docRef.update({
        'likes': FieldValue.arrayUnion([uid]),
        'likesCount': FieldValue.increment(1),
      });
    }

    final updatedPosts = state.posts.map((p) {
      if (p.postId == post.postId) {
        final updatedLikes = List<String>.from(post.likes);
        if (post.likes.contains(uid)) {
          updatedLikes.remove(uid);
        } else {
          updatedLikes.add(uid);
        }

        return p.copyWith(
          likes: updatedLikes,
          likesCount: post.likesCount + (post.likes.contains(uid) ? -1 : 1),
        );
      }
      return p;
    }).toList();

    state = state.copyWith(posts: updatedPosts);
  }
}
