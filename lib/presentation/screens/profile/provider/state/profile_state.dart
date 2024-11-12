class ProfileState {
  final User? user;
  final bool isLoading;
  final String error;

  ProfileState({
    this.user,
    this.isLoading = false,
    this.error = '',
  });

  ProfileState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// user_model.dart
class User {
  final String id;
  final String username;
  final String profileImageUrl;
  final String bio;
  final int followers;
  final int following;
  final int posts;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.profileImageUrl,
    required this.bio,
    required this.followers,
    required this.following,
    required this.posts,
    required this.email,
  });

  User copyWith({
    String? id,
    String? username,
    String? profileImageUrl,
    String? bio,
    int? followers,
    int? following,
    int? posts,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      posts: posts ?? this.posts,
      email: email ?? this.email,
    );
  }
}
