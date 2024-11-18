import 'package:sns_app/domain/repositories/signup/signup_repository.dart';

class SignupUsecase {
  final SignupRepository _repository;

  SignupUsecase(this._repository);

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _repository.createUserWithEmailAndPassword(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addUserToFirestore(String nickname, String email) async {
    try {
      await _repository.addUserToFirestore(nickname, email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    _repository.sendEmailVerification();
  }
}
