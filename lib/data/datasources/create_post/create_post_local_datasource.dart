import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/di/injector.dart';

class CreatePostLocalDatasource {
  final Database db = injector.get<Database>();

  Future<void> createPost(
      String content, File? imageFile, DateTime createAt) async {
    // 이미지 저장 경로 생성
    final directory = await getApplicationDocumentsDirectory();
    // 이미지 파일명 생성: 시간를 기준으로, 원본 파일 확장자 유지
    final fileExtension = extension(imageFile!.path); // .png, .jpg 등등
    final imageName = "${createAt.toIso8601String()}$fileExtension";
    final imagePath = join(directory.path, imageName);
    // 이미지 저장
    await imageFile.copy(imagePath); // 나중에 imagePath를 통해서 storage에 업로드 + 제거 해야함
    // DB에 추가
    await db.insert('create_post', {
      'content': content,
      'imagePath': imagePath,
      'createdAt': createAt.toIso8601String(),
    });
  }
}
