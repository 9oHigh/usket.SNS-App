import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns_app/data/models/user_model.dart';

class PostModel {
  final String postId;
  final String uid;
  final String imageUrl;
  final String content;
  final int likeCount;
  final int commentCount;
  final Timestamp createdAt;
  final UserModel? userInfo;

  PostModel({
    required this.postId,
    required this.uid,
    required this.imageUrl,
    required this.content,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    this.userInfo,
  });

  factory PostModel.initial() {
    return PostModel(
        postId: "",
        uid: "",
        imageUrl: "",
        content: "",
        likeCount: 0,
        commentCount: 0,
        createdAt: Timestamp.fromDate(DateTime.now()));
  }

  factory PostModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      postId: doc.id,
      uid: data['uid'],
      imageUrl: data['imageUrl'],
      content: data['content'],
      likeCount: data['likeCount'] as int,
      commentCount: data['commentCount'] as int,
      createdAt: data['createdAt'],
      userInfo: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'uid': uid,
      'imageUrl': imageUrl,
      'content': content,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'createdAt': createdAt,
    };
  }

  PostModel copyWith({
    String? postId,
    String? uid,
    String? imageUrl,
    String? content,
    int? likeCount,
    int? commentCount,
    Timestamp? createdAt,
    UserModel? userInfo,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      uid: uid ?? this.uid,
      imageUrl: imageUrl ?? this.imageUrl,
      content: content ?? this.content,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      userInfo: userInfo ?? this.userInfo,
    );
  }
}
