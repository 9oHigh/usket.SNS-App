import 'dart:io';

class CreatePostState {
  final File? selectedImage;
  final String? content;
  final bool isUploading;

  CreatePostState({
    this.selectedImage,
    this.content,
    this.isUploading = false,
  });

  CreatePostState copyWith({
    File? selectedImage,
    String? content,
    bool? isUploading,
  }) {
    return CreatePostState(
      selectedImage: selectedImage ?? this.selectedImage,
      content: content ?? this.content,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}
