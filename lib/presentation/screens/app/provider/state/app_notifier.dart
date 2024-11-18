import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/presentation/screens/app/provider/state/app_state.dart';

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier() : super(AppState());

  void setErrorMessage(String message) {
    state = state.copyWith(errorMessage: message);
  }

  void updateBottomNavIndex(int index) {
    state = state.copyWith(bottomNavIndex: index);
  }
}
