import 'dart:io';
import 'package:sns_app/domain/repositories/create_post/create_post_remote_repository.dart';

class CreatePostRemoteUsecase {
  final CreatePostRemoteRepository _repository;

  CreatePostRemoteUsecase(this._repository);

  Future<void> createPost(String content, File? file, DateTime createAt) async {
    await _repository.createPost(content, file, createAt);
  }
}
