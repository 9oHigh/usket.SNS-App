import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String uid;
  final String username;
  final String profileImageUrl;
  final String imageUrl;
  final String caption;
  final int likesCount;
  final List<String> likes;
  final Timestamp createdAt;

  PostModel({
    required this.postId,
    required this.uid,
    required this.username,
    required this.profileImageUrl,
    required this.imageUrl,
    required this.caption,
    required this.likesCount,
    required this.likes,
    required this.createdAt,
  });

  factory PostModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      postId: doc.id,
      uid: data['uid'],
      username: data['username'],
      profileImageUrl: data['profileImageUrl'],
      imageUrl: data['imageUrl'],
      caption: data['caption'],
      likesCount: data['likesCount'] ?? 0,
      likes: List<String>.from(data['likes'] ?? []),
      createdAt: data['createdAt'],
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
      'createdAt': createdAt,
    };
  }

  // copyWith 메서드 추가
  PostModel copyWith({
    String? postId,
    String? uid,
    String? username,
    String? profileImageUrl,
    String? imageUrl,
    String? caption,
    int? likesCount,
    List<String>? likes,
    Timestamp? createdAt,
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
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
