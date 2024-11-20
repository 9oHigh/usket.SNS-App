import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sns_app/data/models/user_model.dart' as signup;

class SignupDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Reference _storageRef =
      FirebaseStorage.instance.ref('profile_images/default_profile_image.png');

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    _auth.currentUser?.sendEmailVerification();
  }

  Future<String> getDefaultProfileImageUrl() async {
    return await _storageRef.getDownloadURL();
  }

  Future<void> addUserToFirestore(String nickname, String email) async {
    final uid = _auth.currentUser!.uid;
    final token = await FirebaseMessaging.instance.getToken();
    try {
      final defaultProfileImageUrl = await getDefaultProfileImageUrl();
      final signup.UserModel user = signup.UserModel(
        uid: uid,
        nickname: nickname,
        email: email,
        profileImageUrl: defaultProfileImageUrl,
        bio: "안녕하세요.",
        postIds: [],
        followers: 0,
        followings: 0,
        fcmToken: token ?? "",
      );

      await _firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(user.toJson());
      await _firebaseFirestore
          .collection('followers')
          .doc(user.uid)
          .set({"userFollowers": []});
      await _firebaseFirestore
          .collection('followings')
          .doc(user.uid)
          .set({"userFollowings": []});
    } catch (e) {
      rethrow;
    }
  }

}
