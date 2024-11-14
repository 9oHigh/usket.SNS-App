import 'dart:io';

abstract class CreatePostLocalRepository {
  Future<void> createPost(String content, File? imageFile, DateTime createAt);
}
