import 'package:sns_app/data/datasources/signup/signup_datasource.dart';
import 'package:sns_app/domain/repositories/signup/signup_repository.dart';

class SignupRepositoryImpl extends SignupRepository {
  final SignupDatasource _datasource;

  SignupRepositoryImpl(this._datasource);

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _datasource.createUserWithEmailAndPassword(email, password);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addUserToFirestore(String nickname, String email) async {
    try {
      await _datasource.addUserToFirestore(nickname, email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    _datasource.sendEmailVerification();
  }
}
