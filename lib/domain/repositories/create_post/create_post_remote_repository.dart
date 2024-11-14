import 'dart:io';

abstract class CreatePostRemoteRepository {
  Future<void> createPost(String content, File? file, DateTime createAt);
}
