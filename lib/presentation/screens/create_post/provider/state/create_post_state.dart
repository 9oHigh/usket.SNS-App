import 'dart:io';

class CreatePostState {
  final File? image;
  final String content;
  final bool isLoading;
  final String? error;

  CreatePostState({
    this.image,
    this.content = "",
    this.isLoading = false,
    this.error,
  });

  CreatePostState copyWith({
    File? image,
    String? content,
    bool? isLoading,
    String? error,
  }) {
    return CreatePostState(
      image: image ?? this.image,
      content: content ?? this.content,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
