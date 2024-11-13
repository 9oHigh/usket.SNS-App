import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/presentation/screens/create_post/provider/state/create_post_state.dart';

class CreatePostNotifier extends StateNotifier<CreatePostState> {
  CreatePostNotifier() : super(CreatePostState.initial());

  Future<void> uploadPost(String uid, String username, String profileImageUrl,
      String caption, File imageFile) async {
    state = state.copyWith(isLoading: true);

    try {
      final postId = FirebaseFirestore.instance.collection('posts').doc().id;
      final imageUrl = await FirebaseStorage.instance
          .ref('posts/$postId.jpg')
          .putFile(imageFile)
          .then((snapshot) => snapshot.ref.getDownloadURL());

      final post = PostModel(
        postId: postId,
        uid: uid,
        username: username,
        profileImageUrl: profileImageUrl,
        imageUrl: imageUrl,
        caption: caption,
        likesCount: 0,
        likes: [],
        createdAt: Timestamp.now(),
      );

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .set(post.toJson());

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
