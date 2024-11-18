class AppState {
  final String? errorMessage;
  final int bottomNavIndex;

  AppState({
    this.errorMessage = "",
    this.bottomNavIndex = 0,
  });

  AppState copyWith({
    String? errorMessage,
    int? bottomNavIndex,
  }) {
    return AppState(
        errorMessage: errorMessage ?? this.errorMessage,
        bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex);
  }
}
