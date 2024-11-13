import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String profileImageUrl;
  final String bio;
  final int followers;
  final int following;
  final int posts;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.profileImageUrl,
    required this.bio,
    required this.followers,
    required this.following,
    required this.posts,
    required this.email,
  });

  User copyWith({
    String? id,
    String? username,
    String? profileImageUrl,
    String? bio,
    int? followers,
    int? following,
    int? posts,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      posts: posts ?? this.posts,
      email: email ?? this.email,
    );
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      username: data['username'],
      profileImageUrl: data['profileImageUrl'],
      bio: data['bio'],
      followers: data['followers'] ?? 0,
      following: data['following'] ?? 0,
      posts: data['posts'] ?? 0,
      email: data['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'followers': followers,
      'following': following,
      'posts': posts,
      'email': email,
    };
  }
}
