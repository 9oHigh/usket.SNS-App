import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sns_app/core/constants/sizes.dart';
import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/presentation/screens/feed/provider/feed_notifier_provider.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedNotifier = ref.read(feedNotifierProvider.notifier);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text(
          '사용자 정보가 없습니다.',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    final uid = user.uid;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getWidth(context) * 0.025,
              vertical: getHeight(context) * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(post.imageUrl),
                      onBackgroundImageError: (error, stackTrace) {},
                      child:
                          const Icon(Icons.account_circle, color: Colors.grey),
                    ),
                    SizedBox(width: getWidth(context) * 0.025),
                    Text(
                      post.uid,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Icon(Icons.more_vert),
              ],
            ),
          ),
          Image.network(
            post.imageUrl,
            width: getWidth(context),
            height: getWidth(context),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.broken_image,
                size: getWidth(context),
                color: Colors.grey,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(post.content),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () => feedNotifier.toggleLike(post, uid),
              ),
              Text('${post.likeCount} likes'),
            ],
          ),
        ],
      ),
    );
  }
}
