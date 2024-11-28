import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore 임포트
import 'package:sns_app/data/repositories/user/user_repository.dart';
import 'package:sns_app/presentation/screens/profile/provider/state/profile_notifier.dart';
import 'package:sns_app/presentation/screens/profile/provider/state/profile_state.dart';

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final userRepository = UserRepository(FirebaseFirestore.instance);
  return ProfileNotifier(userRepository);
});
