import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/presentation/screens/post_detail/provider/state/post_detail_notifier.dart';
import 'package:sns_app/presentation/screens/post_detail/provider/state/post_detail_state.dart';

final postDetailNotifierProvider =
    AutoDisposeStateNotifierProvider<PostDetailNotifier, PostDetailState>(
        (ref) => PostDetailNotifier());
