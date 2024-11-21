import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/presentation/screens/post_detail/provider/post_detail_notifier_provider.dart';
import 'package:sns_app/presentation/screens/post_detail/provider/state/post_detail_notifier.dart';
import 'package:sns_app/presentation/screens/post_detail/provider/state/post_detail_state.dart';
import 'package:sns_app/presentation/widgets/comment_card.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final PostModel post;

  const PostDetailScreen({super.key, required this.post});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postDetailNotifierProvider.notifier).initPost(widget.post);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postDetailState = ref.watch(postDetailNotifierProvider);
    final postDetailNotifier = ref.read(postDetailNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "게시물 상세",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: main_color,
      ),
      body: postDetailState.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: main_color),
            )
          : Column(
              children: [
                _buildPostContent(context, postDetailState.post,
                    postDetailState, postDetailNotifier),
                const Divider(thickness: 1),
                postDetailState.error != null
                    ? Center(child: Text(postDetailState.error!))
                    : Expanded(
                        child: postDetailState.comments.isEmpty
                            ? const Center(child: Text("댓글이 없습니다."))
                            : ListView.builder(
                                itemCount: postDetailState.comments.length,
                                itemBuilder: (context, index) {
                                  final comment =
                                      postDetailState.comments[index];
                                  return CommentCard(comment: comment);
                                },
                              ),
                      ),
                _buildCommentInput(context, postDetailNotifier),
              ],
            ),
    );
  }

  Widget _buildPostContent(BuildContext context, PostModel? post,
      PostDetailState state, PostDetailNotifier notifier) {
    if (post == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(post.userInfo?.profileImageUrl ??
                "https://firebasestorage.googleapis.com/v0/b/elice-project2-team1.firebasestorage.app/o/profile_images%2F8FNzbWQuyXVNFBeEaHoFt9hpxbC3?alt=media&token=1ee35bb2-7653-40d1-a4ec-91cb24b14ddf"),
          ),
          title: Text(post.userInfo?.nickname ?? "Unknown"),
        ),
        if (post.imageUrl.isNotEmpty)
          Image.network(
            post.imageUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            post.content,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              FutureBuilder(
                  future: notifier.isLikedByCurrentUser(),
                  builder: (context, snapshot) {
                    final isLiked = snapshot.data ?? false;
                    return IconButton(
                      onPressed: () {
                        notifier.toggleLike();
                      },
                      icon: Icon(Icons.favorite,
                          color: isLiked ? Colors.red : Colors.grey),
                    );
                  }),
              Text(' ${post.likeCount}'),
              const SizedBox(width: 16),
              const Icon(Icons.comment, color: Colors.grey),
              Text(' ${post.commentCount}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentInput(
      BuildContext context, PostDetailNotifier postDetailNotifier) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: "댓글을 입력하세요...",
                hintStyle: TextStyle(color: Color.fromARGB(255, 192, 191, 191)),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: main_color),
            onPressed: () async {
              final content = _commentController.text;
              if (content.isNotEmpty) {
                await postDetailNotifier.addComment(content);
                _commentController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
