import 'package:firebase_auth/firebase_auth.dart';

abstract class SigninRepository {
  Future<User?> signIn(String email, String password);
}
