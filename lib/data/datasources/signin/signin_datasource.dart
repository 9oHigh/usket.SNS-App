import 'package:firebase_auth/firebase_auth.dart';

class SigninDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
}
