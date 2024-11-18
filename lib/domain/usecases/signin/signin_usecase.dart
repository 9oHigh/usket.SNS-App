import 'package:firebase_auth/firebase_auth.dart';
import 'package:sns_app/domain/repositories/signin/signin_repository.dart';

class SigninUsecase {
  final SigninRepository _repository;
  SigninUsecase(this._repository);

  Future<User?> signIn(String email, String password) async {
    try {
      return await _repository.signIn(email, password);
    } catch (e) {
      rethrow;
    }
  }
}
