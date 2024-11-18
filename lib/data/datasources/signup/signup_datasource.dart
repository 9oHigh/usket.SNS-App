import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sns_app/data/models/user_model.dart' as signup;

class SignupDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

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

  Future<void> addUserToFirestore(String nickname, String email) async {
    final uid = _auth.currentUser!.uid;
    final signup.User user = signup.User(
        uid: uid,
        nickname: nickname,
        email: email,
        profileImageUrl: "default",
        bio: "안녕하세요.",
        postIds: [],
        followers: 0,
        followings: 0);
    try {
      await _firebaseFirestore.collection('users').add(user.toJson());
      await _firebaseFirestore
          .collection('followers')
          .add({"userFollowers": []});
      await _firebaseFirestore
          .collection('followings')
          .add({"userFollowings": []});
    } catch (e) {
      rethrow;
    }
  }
}
