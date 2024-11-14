import 'dart:io';
import 'package:sns_app/data/datasources/create_post/create_post_remote_datasource.dart';
import 'package:sns_app/domain/repositories/create_post/create_post_remote_repository.dart';

class CreatePostRemoteRepositoryImpl extends CreatePostRemoteRepository {
  final CreatePostRemoteDatasource _datasource;

  CreatePostRemoteRepositoryImpl(this._datasource);

  @override
  Future<void> createPost(String content, File? file, DateTime createAt) async {
    await _datasource.createPost(content, file, createAt);
  }
}
