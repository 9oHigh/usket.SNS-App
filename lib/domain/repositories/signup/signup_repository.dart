abstract class SignupRepository {
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> addUserToFirestore(String nickname, String email);
  Future<void> sendEmailVerification();
}
