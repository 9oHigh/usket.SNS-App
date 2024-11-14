import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/core/di/injector.dart';
import 'package:sns_app/domain/usecases/create_post/create_post_local_usecase.dart';
import 'package:sns_app/domain/usecases/create_post/create_post_remote_usecase.dart';
import 'package:sns_app/presentation/screens/create_post/provider/state/create_post_state.dart';

class CreatePostNotifier extends StateNotifier<CreatePostState> {
  final CreatePostLocalUsecase _localUsecase =
      injector.get<CreatePostLocalUsecase>();
  final CreatePostRemoteUsecase _remoteUsecase =
      injector.get<CreatePostRemoteUsecase>();
  // 로그인 초기에 DB에 저장해서 사용해주세용
  final userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  CreatePostNotifier() : super(CreatePostState());

  void setImage(File image) {
    state = state.copyWith(image: image);
  }

  Future<void> uploadPost(String content) async {
    final DateTime createdAt = DateTime.now();
    final File? imageFile = state.image;

    state = state.copyWith(isLoading: true);
    
    try {
      await _localUsecase.createPost(content, imageFile, createdAt);
      await _remoteUsecase.createPost(content, imageFile, createdAt);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
