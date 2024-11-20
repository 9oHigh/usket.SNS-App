import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        state = state.copyWith(isLoading: false);
        return;
      }
      final user = await userRepository.getUserById(uid);
      if (user != null) {
        state = state.copyWith(user: user, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
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
      state = state.copyWith(user: updatedUser, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}
