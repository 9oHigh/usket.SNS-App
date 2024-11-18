import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/presentation/screens/app/provider/state/app_notifier.dart';
import 'package:sns_app/presentation/screens/app/provider/state/app_state.dart';

final appNotifierProvider =
    AutoDisposeStateNotifierProvider<AppNotifier, AppState>(
        (ref) => AppNotifier());
