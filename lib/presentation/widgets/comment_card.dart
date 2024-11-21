import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sns_app/data/models/comment_model.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;

  const CommentCard({super.key, required this.comment});

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate().toLocal();
    return DateFormat('MM/dd HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(comment.profileImageUrl),
      ),
      title: Text(
        comment.nickname,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: Text(
        comment.content,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Text(
        formatDate(comment.createdAt),
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}
