import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String bio;
  final String nickname;
  final String email;
  final String profileImageUrl;
  final int followers;
  final int followings;
  final List<dynamic> postIds;
  final String fcmToken;

  UserModel({
    required this.uid,
    required this.bio,
    required this.nickname,
    required this.email,
    required this.profileImageUrl,
    required this.followers,
    required this.followings,
    required this.postIds,
    required this.fcmToken,
  });

  UserModel copyWith({
    String? uid,
    String? bio,
    String? nickname,
    String? email,
    String? profileImageUrl,
    int? followers,
    int? followings,
    List<dynamic>? postIds,
    String? fcmToken,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      postIds: postIds ?? this.postIds,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] == null ? '' : json['uid'] as String,
      bio: json['bio'] == null ? '' : json['bio'] as String,
      nickname: json['nickname'] == null ? '' : json['nickname'] as String,
      email: json['email'] == null ? '' : json['email'] as String,
      profileImageUrl: json['profileImageUrl'] == null
          ? ''
          : json['profileImageUrl'] as String,
      followers: json['followers'] == null ? 0 : json['followers'] as int,
      followings: json['followings'] == null ? 0 : json['followings'] as int,
      postIds: json['postIds'] == null ? [] : json['postIds'] as List<dynamic>,
      fcmToken: json['fcmToken'] as String,
    );
  }

  factory UserModel.init() {
    return UserModel(
      uid: '',
      bio: '',
      nickname: '',
      email: '',
      profileImageUrl: '',
      followers: 0,
      followings: 0,
      postIds: [],
      fcmToken: "",
    );
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] ?? '',
      bio: data['bio'] ?? '',
      nickname: data['nickname'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      followers: data['followers'] ?? 0,
      followings: data['followings'] ?? 0,
      postIds: List<String>.from(data['postIds'] ?? []),
      email: data['email'] ?? '',
      fcmToken: data['fcmToken'],
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
      'fcmToken': fcmToken,
    };
  }
}
