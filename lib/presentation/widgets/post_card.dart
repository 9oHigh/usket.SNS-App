import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/core/constants/sizes.dart';
import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/presentation/screens/feed/provider/feed_notifier_provider.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedNotifier = ref.read(feedNotifierProvider.notifier);
    const uid = 'YOUR_USER_ID';

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getWidth(context) * 0.025,
                vertical: getHeight(context) * 0.01),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(post.userInfo.profileImageUrl),
                        onBackgroundImageError: (error, stackTrace) {
                          // 프로필 이미지 로딩 실패 시 대체 아이콘 표시
                        },
                        child: const Icon(Icons.account_circle,
                            color: Colors.grey), // 대체 아이콘
                      ),
                      SizedBox(width: getWidth(context) * 0.025),
                      Text(post.userInfo.nickname,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Icon(Icons.more_vert),
                ]),
          ),
          Image.network(
            post.thumbnail,
            width: getWidth(context),
            height: getWidth(context),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.broken_image,
                size: getWidth(context),
                color: Colors.grey,
              ); // 게시물 이미지 로딩 실패 시 대체 아이콘 표시
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(post.description),
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
              Text('${post.likeCount} likes'),
            ],
          ),
        ],
      ),
    );
  }
}
