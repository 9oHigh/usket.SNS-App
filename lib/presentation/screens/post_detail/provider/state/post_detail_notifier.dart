import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/core/manager/shared_preferences_manager.dart';
import 'package:sns_app/data/models/comment_model.dart';
import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/data/models/user_model.dart';
import 'package:sns_app/presentation/screens/post_detail/provider/state/post_detail_state.dart';

class PostDetailNotifier extends StateNotifier<PostDetailState> {
  PostDetailNotifier() : super(PostDetailState(isLoading: true));

  PostModel post = PostModel.initial();

  void initPost(PostModel post) {
    resetPostDetail();
    state = state.copyWith(post: post);
    initialize();
  }

  Future<void> initialize() async {
    try {
      state = state.copyWith(isLoading: true);

      final commentsSnapshot = await FirebaseFirestore.instance
          .collection("posts")
          .doc(state.post?.postId)
          .collection("comments")
          .orderBy("createdAt", descending: false)
          .get();
      final postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(state.post?.postId)
          .get();

      final comments = commentsSnapshot.docs.map((doc) {
        return CommentModel.fromDocument(doc);
      }).toList();

      final getPost = PostModel.fromDocument(postSnapshot);
      final userSnapShot = await FirebaseFirestore.instance
          .collection('users')
          .doc(getPost.uid)
          .get();
      final user = UserModel.fromDocument(userSnapShot);
      final newPost = state.post?.copyWith(userInfo: user);

      state = state.copyWith(
        post: newPost,
        comments: comments,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, comments: []);
    }
  }

  Future<void> toggleLike() async {
    final userId =
        SharedPreferenceManager().getPref<String>(PrefsType.userId) ?? "";
    final nickname =
        SharedPreferenceManager().getPref<String>(PrefsType.nickname) ?? "유저";
    final likeDocRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(state.post?.postId)
        .collection('likes')
        .doc(userId);
    final postDocRef =
        FirebaseFirestore.instance.collection('posts').doc(state.post?.postId);
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
    PostModel? newPost = state.post?.copyWith(
        likeCount: disLike ? post.likeCount - 1 : post.likeCount + 1);
    state = state.copyWith(post: newPost);
  }

  Future<bool> isLikedByCurrentUser() async {
    final userId =
        SharedPreferenceManager().getPref<String>(PrefsType.userId) ?? "";
    final likeDocRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(state.post?.postId)
        .collection('likes')
        .doc(userId);

    final likeDocSnapshot = await likeDocRef.get();
    return likeDocSnapshot.exists;
  }

  Future<void> addComment(String content) async {
    try {
      final userId =
          SharedPreferenceManager().getPref<String>(PrefsType.userId) ?? "";
      final userDocSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      final nickname = userDocSnapshot.data()?['nickname'];
      final String profileImageUrl = userDocSnapshot.data()?['profileImageUrl'];
      final commentData = {
        'uid': userId,
        'nickname': nickname,
        'profileImageUrl': profileImageUrl,
        'content': content,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final commentDocRef = await FirebaseFirestore.instance
          .collection("posts")
          .doc(state.post?.postId)
          .collection("comments")
          .add(commentData);

      final newComment = CommentModel(
        uid: userId,
        nickname: nickname,
        profileImageUrl: profileImageUrl,
        content: content,
        createdAt: Timestamp.fromDate(DateTime.now()),
      );

      state = state.copyWith(
        comments: [...state.comments, newComment],
      );
    } catch (e) {
      state = state.copyWith(
        error: "댓글 추가에 실패했습니다. $e",
      );
    }
  }

  void resetPostDetail() {
    state = PostDetailState();
  }
}
