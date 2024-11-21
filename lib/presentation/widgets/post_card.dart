import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/presentation/screens/feed/provider/feed_notifier_provider.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedNotifier = ref.read(feedNotifierProvider.notifier);
    const String defaultProfileUrl =
        "https://firebasestorage.googleapis.com/v0/b/elice-project2-team1.firebasestorage.app/o/posts%2F8FNzbWQuyXVNFBeEaHoFt9hpxbC3%2Fss_b349668fe7de40d36b1a8aedb1070d3e6ca74078.1920x1080.jpg?alt=media&token=c2a9fe27-cdbd-4b72-a5ab-e3a8ce32ce2f";

    bool isImageLoading = true;

    void onImageLoadComplete(bool success) {
      isImageLoading = !success;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  post.userInfo?.profileImageUrl ?? defaultProfileUrl),
              onBackgroundImageError: (_, __) =>
                  const Icon(Icons.account_circle),
            ),
            title: Text(post.userInfo?.nickname ?? "Unkown"),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                post.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) {
                  return const Icon(Icons.broken_image);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    onImageLoadComplete(true);
                    return child;
                  } else {
                    onImageLoadComplete(false);
                    return Center(
                      child: SizedBox(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: main_color,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              if (!isImageLoading) Container()
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(post.content),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FutureBuilder<bool>(
                  future: feedNotifier.isLikedByCurrentUser(post.postId),
                  builder: (context, snapshot) {
                    final isLiked = snapshot.data ?? false;

                    return IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        feedNotifier.toggleLike(post.postId);
                      },
                    );
                  },
                ),
                Text('${post.likeCount}'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.comment, color: Colors.grey),
                  onPressed: () {
                    context.push('/postDetail', extra: post);
                  },
                ),
                Text('${post.commentCount}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
