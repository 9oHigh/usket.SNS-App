import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String uid;
  final String content;
  final Timestamp createdAt;
  final String nickname;
  final String profileImageUrl;

  CommentModel({
    required this.uid,
    required this.content,
    required this.createdAt,
    required this.nickname,
    required this.profileImageUrl,
  });

  factory CommentModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      uid: data['uid'],
      content: data['content'],
      createdAt: data['createdAt'],
      nickname: data['nickname'],
      profileImageUrl: data['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'content': content,
      'createdAt': createdAt,
      'nickname': nickname,
      'profileImageUrl': profileImageUrl,
    };
  }

  CommentModel copyWith({
    String? commentId,
    String? uid,
    String? content,
    Timestamp? createdAt,
    String? nickname,
    String? profileImageUrl,
  }) {
    return CommentModel(
      uid: uid ?? this.uid,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      nickname: nickname ?? this.nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
