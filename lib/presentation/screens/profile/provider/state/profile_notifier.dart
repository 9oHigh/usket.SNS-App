import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/data/repositories/user_repository.dart';
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final UserRepository userRepository;

  ProfileNotifier(this.userRepository) : super(ProfileState(isLoading: true)) {
    loadUser();
  }

  Future<String?> _getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> loadUser() async {
    try {
      state = state.copyWith(isLoading: true);
      final uid = await _getCurrentUserId();
      if (uid == null) {
        print('No logged-in user.');
        state = state.copyWith(isLoading: false);
        return;
      }

      final user = await userRepository.getUserById(uid);
      if (user != null) {
        print('User loaded: ${user.nickname}');
        state = state.copyWith(user: user);
        await loadUserPosts(uid);
      } else {
        print('User not found in Firestore.');
      }
    } catch (e) {
      print('Error loading user: $e');
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadUserPosts(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .get();

      if (snapshot.docs.isEmpty) {
        print('사용자의 게시물이 없습니다.');
      } else {
        print('게시물 수: ${snapshot.docs.length}');
      }

      final posts = snapshot.docs
          .map((doc) => PostModel.fromDocument(doc))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      state = state.copyWith(userPosts: posts);
    } catch (e) {
      print('게시물 로드 오류: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateProfile({
    String? nickname,
    String? bio,
    File? imageFile,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final user = state.user;

      if (user == null) return;

      String? imageUrl = user.profileImageUrl;

      if (imageFile != null) {
        final storageRef =
            FirebaseStorage.instance.ref().child('profile_images/${user.uid}');
        await storageRef.putFile(imageFile);
        imageUrl = await storageRef.getDownloadURL();
      }
      final updatedUser = user.copyWith(
        nickname: nickname ?? user.nickname,
        bio: bio ?? user.bio,
        profileImageUrl: imageUrl,
      );

      await userRepository.createUser(updatedUser);
      state = state.copyWith(user: updatedUser);
    } catch (e) {
      print('Error updating profile: $e');
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
