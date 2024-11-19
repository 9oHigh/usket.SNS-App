import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/data/models/user_model.dart';
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState());

  Future<void> loadUserProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: '');
    try {
      await Future.delayed(const Duration(seconds: 2));

      UserModel exampleUser = UserModel(
        uid: userId,
        nickname: "john_doe",
        profileImageUrl: "https://example.com/profile.jpg",
        bio: "Flutter developer and tech enthusiast.",
        followers: 1200,
        followings: 300,
        postIds: [],
        email: 'john_doe@example.com',
      );

      state = state.copyWith(user: exampleUser, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Failed to load profile");
    }
  }

  Future<void> updateUserProfile(
      String newUsername, String newProfileImageUrl) async {
    if (state.user != null) {
      UserModel updatedUser = state.user!.copyWith(
        nickname: newUsername,
        profileImageUrl: newProfileImageUrl,
      );
      state = state.copyWith(user: updatedUser);
    }
  }
}
