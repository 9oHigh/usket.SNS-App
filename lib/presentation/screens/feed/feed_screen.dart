import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/presentation/screens/feed/provider/feed_notifier_provider.dart';
import 'package:sns_app/presentation/widgets/post_card.dart';

class FeedScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(feedNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: feedState.isLoading
          ? Center(child: CircularProgressIndicator())
          : feedState.error != null
              ? Center(child: Text(feedState.error!))
              : ListView.builder(
                  itemCount: feedState.posts.length,
                  itemBuilder: (context, index) {
                    final post = feedState.posts[index];
                    return PostCard(post: post);
                  },
                ),
    );
  }
}
