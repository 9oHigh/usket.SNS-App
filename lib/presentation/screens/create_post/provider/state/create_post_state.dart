class CreatePostState {
  final bool isLoading;
  final String? error;

  CreatePostState({required this.isLoading, this.error});

  CreatePostState copyWith({bool? isLoading, String? error}) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  factory CreatePostState.initial() {
    return CreatePostState(isLoading: false);
  }
}
