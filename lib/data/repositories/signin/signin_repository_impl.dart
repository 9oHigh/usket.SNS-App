import 'package:firebase_auth/firebase_auth.dart';
import 'package:sns_app/data/datasources/signin/signin_datasource.dart';
import 'package:sns_app/domain/repositories/signin/signin_repository.dart';

class SigninRepositoryImpl extends SigninRepository {
  final SigninDatasource _datasource;

  SigninRepositoryImpl(this._datasource);

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      return await _datasource.signIn(email, password);
    } catch (e) {
      rethrow;
    }
  }
}
