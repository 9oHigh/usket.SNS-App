import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String bio;
  final String nickname;
  final String email;
  final String profileImageUrl;
  final int followers;
  final int followings;
  final List<String> postIds;

  User({
    required this.uid,
    required this.bio,
    required this.nickname,
    required this.email,
    required this.profileImageUrl,
    required this.followers,
    required this.followings,
    required this.postIds,
  });

  User copyWith({
    String? uid,
    String? bio,
    String? nickname,
    String? email,
    String? profileImageUrl,
    int? followers,
    int? followings,
    List<String>? postIds,
  }) {
    return User(
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      postIds: postIds ?? this.postIds,
    );
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      uid: data['uid'],
      bio: data['bio'],
      nickname: data['nickname'],
      profileImageUrl: data['profileImageUrl'],
      followers: data['followers'] ?? 0,
      followings: data['following'] ?? 0,
      postIds: List<String>.from(data['posts'] ?? []),
      email: data['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nickname': nickname,
      'bio': bio,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'followings': followings,
      'postIds': postIds,
    };
  }
}