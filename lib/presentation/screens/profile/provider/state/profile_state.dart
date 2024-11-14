import 'package:sns_app/data/models/user_model.dart';

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
