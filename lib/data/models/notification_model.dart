import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String type;
  final String postId;
  final String uid;
  final String message;
  final Timestamp createdAt;

  NotificationModel({
    required this.type,
    required this.postId,
    required this.uid,
    required this.message,
    required this.createdAt,
  });

  factory NotificationModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      type: data['type'],
      postId: data['postId'],
      uid: data['userId'],
      message: data['message'],
      createdAt: data['createdAt'],
    );
  }
}
