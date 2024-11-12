import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState());

  Future<void> loadUserProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: '');
    try {
      await Future.delayed(Duration(seconds: 2));

      User exampleUser = User(
        id: userId,
        username: "john_doe",
        profileImageUrl: "https://example.com/profile.jpg",
        bio: "Flutter developer and tech enthusiast.",
        followers: 1200,
        following: 300,
        posts: 45,
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
      User updatedUser = state.user!.copyWith(
        username: newUsername,
        profileImageUrl: newProfileImageUrl,
      );
      state = state.copyWith(user: updatedUser);
    }
  }
}
