import 'dart:io';
import 'package:sns_app/domain/repositories/create_post/create_post_local_repository.dart';

class CreatePostLocalUsecase {
  final CreatePostLocalRepository _repository;

  CreatePostLocalUsecase(this._repository);

  Future<void> createPost(
      String content, File? imageFile, DateTime createAt) async {
    _repository.createPost(content, imageFile, createAt);
  }
}
