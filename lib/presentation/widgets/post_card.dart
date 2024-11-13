import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/presentation/screens/feed/provider/feed_notifier_provider.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;

  PostCard({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedNotifier = ref.read(feedNotifierProvider.notifier);
    final uid = 'YOUR_USER_ID';

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.profileImageUrl),
            ),
            title: Text(post.username),
            trailing: Icon(Icons.more_vert),
          ),
          Image.network(post.imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(post.caption),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: post.likes.contains(uid) ? Colors.red : Colors.grey,
                ),
                onPressed: () => feedNotifier.toggleLike(post, uid),
              ),
              Text('${post.likesCount} likes'),
            ],
          ),
        ],
      ),
    );
  }
}
