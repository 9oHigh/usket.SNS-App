import 'dart:io';

import 'package:sns_app/data/datasources/create_post/create_post_local_datasource.dart';
import 'package:sns_app/domain/repositories/create_post/create_post_local_repository.dart';

class CreatePostLocalRepositoryImpl extends CreatePostLocalRepository {
  final CreatePostLocalDatasource _datasource;

  CreatePostLocalRepositoryImpl(this._datasource);

  @override
  Future<void> createPost(
      String content, File? imageFile, DateTime createAt) async {
    _datasource.createPost(content, imageFile, createAt);
  }
}
