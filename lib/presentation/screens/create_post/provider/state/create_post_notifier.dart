import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import '../state/create_post_state.dart';

class CreatePostNotifier extends StateNotifier<CreatePostState> {
  CreatePostNotifier() : super(CreatePostState());

  void updateSelectedImage(File image) {
    state = state.copyWith(selectedImage: image);
  }

  void updateContent(String content) {
    state = state.copyWith(content: content);
  }

  void resetState() {
    state = CreatePostState();
  }

  Future<void> uploadPost() async {
    final selectedImage = state.selectedImage;
    final content = state.content;

    if (selectedImage == null || content == null || content.trim().isEmpty) {
      throw '이미지와 내용을 모두 입력해야 합니다.';
    }

    try {
      state = state.copyWith(isUploading: true);

      final fileName = basename(selectedImage.path);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('posts/${FirebaseAuth.instance.currentUser!.uid}/$fileName');

      final uploadTask = await storageRef.putFile(selectedImage);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      final post = {
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'imageUrl': imageUrl,
        'content': content,
        'likeCount': 0,
        'commentCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('posts').add(post);
      resetState();
    } catch (_) {
      resetState();
    } finally {
      state = state.copyWith(isUploading: false);
    }
  }
}
