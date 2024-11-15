import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);

  // 로그인
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('로그인 실패: $e');
      rethrow;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('로그아웃 실패: $e');
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
      print('계정 생성 실패: $e');
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
      print('이메일 인증 전송 실패: $e');
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
      print('재인증 실패: $e');
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
      print('사용자 삭제 실패: $e');
      rethrow;
    }
  }
}
