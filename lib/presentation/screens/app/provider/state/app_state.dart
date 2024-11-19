class AppState {
  final String? errorMessage;
  final int bottomNavIndex;
  final int notificationCount;

  AppState({
    this.errorMessage = "",
    this.bottomNavIndex = 0,
    this.notificationCount = 0,
  });

  AppState copyWith({
    String? errorMessage,
    int? bottomNavIndex,
    int? notificationCount,
  }) {
    return AppState(
      errorMessage: errorMessage ?? this.errorMessage,
      bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
      notificationCount: notificationCount ?? this.notificationCount,
    );
  }
}
