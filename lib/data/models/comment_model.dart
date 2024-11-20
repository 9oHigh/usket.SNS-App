import 'package:cloud_firestore/cloud_firestore.dart';

class CommnetModel {
  final String commentId;
  final String uid;
  final String content;
  final Timestamp createdAt;

  CommnetModel({
    required this.commentId,
    required this.uid,
    required this.content,
    required this.createdAt,
  });

  factory CommnetModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommnetModel(
      commentId: doc.id,
      uid: data['uid'],
      content: data['content'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'uid': uid,
      'content': content,
      'createdAt': createdAt,
    };
  }

  CommnetModel copyWith({
    String? commentId,
    String? uid,
    String? content,
    Timestamp? createdAt,
  }) {
    return CommnetModel(
      commentId: commentId ?? this.commentId,
      uid: uid ?? this.uid,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
