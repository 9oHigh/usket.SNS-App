import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns_app/data/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromDocument(doc.data() as DocumentSnapshot<Object?>);
      }
    } catch (e) {
      print("Error getting user: $e");
    }
    return null;
  }
}
