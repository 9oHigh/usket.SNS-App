import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sns_app/data/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  static UserModel? userInfo;

  AuthRepository(this._auth);

  static Future<UserModel?> loginUserByUid(String uid) async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    if (data.size == 0) {
      return null;
    } else {
      return UserModel.fromJson(data.docs.first.data());
    }
  }

  // 로그인
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // 계정 생성
  Future<User?> createUserWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  // 이메일 인증
  Future<void> sendEmailVerification(User user) async {
    try {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      rethrow;
    }
  }

  // 이메일 재인증
  Future<void> reauthenticateEmail(
      User user, String email, String password) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  // 로그인된 사용자
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // 계정 삭제
  Future<void> deleteUser(User user) async {
    try {
      await user.delete();
    } catch (e) {
      rethrow;
    }
  }
}
