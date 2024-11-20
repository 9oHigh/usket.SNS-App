import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/presentation/screens/feed/feed_screen.dart';

class CreatePostFloatingButton extends StatelessWidget {
  final GlobalKey<FeedScreenState>? feedScreenKey;
  const CreatePostFloatingButton({super.key, this.feedScreenKey});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final result = await context.push('/createPost');
        if (result == true && feedScreenKey != null) {
          feedScreenKey!.currentState?.scrollToTopAndRefresh();
        }
      },
      backgroundColor: main_color,
      shape: const CircleBorder(),
      child: const Icon(
        color: Colors.white,
        Icons.add,
      ),
    );
  }
}
