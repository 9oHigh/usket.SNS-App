import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns_app/data/models/user_model.dart';

class PostModel {
  final String postId;
  final String uid;
  final UserModel userInfo;
  final String thumbnail;
  final String description;
  final List<dynamic> likes;
  final int likeCount;
  final Timestamp createdAt;

  PostModel({
    required this.postId,
    required this.uid,
    required this.userInfo,
    required this.thumbnail,
    required this.description,
    required this.likes,
    required this.likeCount,
    required this.createdAt,
  });

  factory PostModel.init(UserModel userInfo) {
    var time = Timestamp.fromDate(DateTime.now());
    return PostModel(
      postId: "0",
      uid: userInfo.uid,
      userInfo: userInfo,
      thumbnail: '',
      description: '',
      likes: [],
      likeCount: 0,
      createdAt: time,
    );
  }

  factory PostModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      postId: doc.id,
      uid: data['uid'],
      userInfo: UserModel.fromJson(data['userInfo']),
      thumbnail: data['thumbnail'],
      description: data['description'],
      likes: data['likes'],
      likeCount: data['likeCount'] ?? 0,
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'uid': uid,
      'userInfo': userInfo.toJson(),
      'thumbnail': thumbnail,
      'description': description,
      'likes': likes,
      'likeCount': likeCount,
      'createdAt': createdAt,
    };
  }

  // copyWith 메서드 추가
  PostModel copyWith({
    String? postId,
    String? uid,
    UserModel? userInfo,
    String? thumbnail,
    String? description,
    List<dynamic>? likes,
    int? likeCount,
    Timestamp? createdAt,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      uid: uid ?? this.uid,
      userInfo: userInfo ?? this.userInfo,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      likeCount: likeCount ?? this.likeCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
