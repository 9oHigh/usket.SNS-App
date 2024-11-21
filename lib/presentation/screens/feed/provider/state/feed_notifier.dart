import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns_app/core/manager/shared_preferences_manager.dart';
import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/data/models/user_model.dart';
import 'package:sns_app/presentation/screens/feed/provider/state/feed_state.dart';

class FeedNotifier extends StateNotifier<FeedState> {
  FeedNotifier() : super(FeedState.initial());

  Future<void> loadFeeds() async {
    state = state.copyWith(isLoading: true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();

      final posts = await Future.wait(snapshot.docs.map((doc) async {
        final post = PostModel.fromDocument(doc);
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(post.uid)
            .get();
        final user = UserModel.fromDocument(userSnapshot);
        return post.copyWith(userInfo: user);
      }).toList());
      final DocumentSnapshot? docSnapshot =
          snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      state = state.copyWith(
          posts: posts, isLoading: false, lastDocument: docSnapshot);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.lastDocument == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .startAfterDocument(state.lastDocument!)
          .limit(5)
          .get();
      final posts = await Future.wait(snapshot.docs.map((doc) async {
        final post = PostModel.fromDocument(doc);
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(post.uid)
            .get();
        final user = UserModel.fromDocument(userSnapshot);
        return post.copyWith(userInfo: user);
      }).toList());

      state = state.copyWith(
        posts: [...state.posts, ...posts],
        isLoading: false,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleLike(String postId) async {
    final userId =
        SharedPreferenceManager().getPref<String>(PrefsType.userId) ?? "";
    final nickname =
        SharedPreferenceManager().getPref<String>(PrefsType.nickname) ?? "유저";
    final likeDocRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userId);
    final postDocRef =
        FirebaseFirestore.instance.collection('posts').doc(postId);
    final likeDocSnapshot = await likeDocRef.get();
    bool disLike = true;

    if (likeDocSnapshot.exists) {
      await likeDocRef.delete();
      await postDocRef.update({
        'likeCount': FieldValue.increment(-1),
      });
    } else {
      await likeDocRef.set({
        'userId': userId,
        'likedAt': FieldValue.serverTimestamp(),
        'nickname': nickname,
      });
      await postDocRef.update({
        'likeCount': FieldValue.increment(1),
      });
      disLike = false;
    }

    List<PostModel> updatedPosts = state.posts.map((post) {
      if (post.postId == postId) {
        return post.copyWith(
            likeCount: disLike ? post.likeCount -1 : post.likeCount + 1);
      } else {
        return post;
      }
    }).toList();

    state = state.copyWith(posts: updatedPosts);
  }

  Future<bool> isLikedByCurrentUser(String postId) async {
    final userId =
        SharedPreferenceManager().getPref<String>(PrefsType.userId) ?? "";
    final likeDocRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userId);

    final likeDocSnapshot = await likeDocRef.get();
    return likeDocSnapshot.exists;
  }
}
