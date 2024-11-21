import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/data/models/user_model.dart';

class ProfileState {
  final UserModel? user;
  final List<PostModel> userPosts;
  final bool isLoading;
  final String error;

  ProfileState({
    this.user,
    this.userPosts = const [],
    this.isLoading = false,
    this.error = '',
  });

  ProfileState copyWith({
    UserModel? user,
    List<PostModel>? userPosts,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      userPosts: userPosts ?? this.userPosts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
