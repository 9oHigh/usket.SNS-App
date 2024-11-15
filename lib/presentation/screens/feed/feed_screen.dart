import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/presentation/screens/feed/provider/feed_notifier_provider.dart';
import 'package:sns_app/presentation/widgets/bottom_nav_bar.dart';
import 'package:sns_app/presentation/widgets/custom_appbar.dart';
import 'package:sns_app/presentation/widgets/custom_floating_button.dart';
import 'package:sns_app/presentation/widgets/post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedNotifier = ref.read(feedNotifierProvider.notifier);
    final feedState = ref.watch(feedNotifierProvider);

    return Scaffold(
      appBar: const CustomAppbar(
        titleText: 'Feed',
        titleAlign: MainAxisAlignment.start,
        titleColor: main_color,
      ),
      body: feedState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : feedState.error != null
              ? Center(child: Text(feedState.error!))
              : ListView.builder(
                  itemCount: feedState.posts.length,
                  itemBuilder: (context, index) {
                    final post = feedState.posts[index];
                    return PostCard(post: post);
                  },
                ),
      floatingActionButton: const CustomFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
