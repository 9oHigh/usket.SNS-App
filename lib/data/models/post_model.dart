class PostModel {
  final String postId;
  final String uid;
  final String username;
  final String profileImageUrl;
  final String imageUrl;
  final String caption;
  final int likesCount;
  final List<String> likes;

  PostModel({
    required this.postId,
    required this.uid,
    required this.username,
    required this.profileImageUrl,
    required this.imageUrl,
    required this.caption,
    required this.likesCount,
    required this.likes,
  });

  factory PostModel.fromDocument(Map<String, dynamic> doc) {
    return PostModel(
      postId: doc['postId'],
      uid: doc['uid'],
      username: doc['username'],
      profileImageUrl: doc['profileImageUrl'],
      imageUrl: doc['imageUrl'],
      caption: doc['caption'],
      likesCount: doc['likesCount'] ?? 0,
      likes: List<String>.from(doc['likes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'uid': uid,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'imageUrl': imageUrl,
      'caption': caption,
      'likesCount': likesCount,
      'likes': likes,
    };
  }

  PostModel copyWith({
    String? postId,
    String? uid,
    String? username,
    String? profileImageUrl,
    String? imageUrl,
    String? caption,
    int? likesCount,
    List<String>? likes,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      likesCount: likesCount ?? this.likesCount,
      likes: likes ?? this.likes,
    );
  }
}
