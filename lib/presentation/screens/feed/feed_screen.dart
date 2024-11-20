import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/presentation/screens/feed/provider/feed_notifier_provider.dart';
import 'package:sns_app/presentation/widgets/post_card.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FeedScreenState();
}

class FeedScreenState extends ConsumerState<FeedScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final feedState = ref.read(feedNotifierProvider);
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!feedState.isLoading) {
        ref.read(feedNotifierProvider.notifier).loadMore();
      }
    }
  }

  void scrollToTopAndRefresh() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    ref.read(feedNotifierProvider.notifier).loadFeeds();
  }

  Future<void> _onRefresh() async {
    await ref.read(feedNotifierProvider.notifier).loadFeeds();
  }

  @override
  Widget build(BuildContext context) {
    final feedNotifier = ref.read(feedNotifierProvider.notifier);
    final feedState = ref.watch(feedNotifierProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (feedState.posts.isEmpty && !feedState.isLoading) {
        feedNotifier.loadFeeds();
      }
    });

    return Scaffold(
      body: RefreshIndicator(
        color: main_color,
        onRefresh: _onRefresh,
        child: feedState.isLoading && feedState.posts.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                color: main_color,
              ))
            : feedState.error != null
                ? Center(child: Text("${feedState.error}"))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: feedState.posts.length + 1,
                    itemBuilder: (context, index) {
                      if (index == feedState.posts.length) {
                        return feedState.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: main_color,
                              ))
                            : const SizedBox.shrink();
                      }
                      final post = feedState.posts[index];
                      return PostCard(post: post);
                    },
                  ),
      ),
    );
  }
}
