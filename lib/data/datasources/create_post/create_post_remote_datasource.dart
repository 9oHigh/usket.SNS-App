import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CreatePostRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Reference _firebaseStorage =
      FirebaseStorage.instance.ref().child("/posts"); // 경로는 상의후에 변경

  Future<void> createPost(
      String content, File? file, DateTime createAt) async {
    // 아래의 코드는 예시 코드임
    if (file != null) {
      // 이미지 저장 경로 생성
      final directory = await getApplicationDocumentsDirectory();
      // 이미지 파일명 생성: 날짜를 기준으로, 원본 파일 확장자 유지
      final fileExtension = extension(file.path); // .png, .jpg 등등
      final imageName = "${createAt.toIso8601String()}$fileExtension";
      final imagePath = join(directory.path, imageName);
      // 이미지 저장 ( 로컬 / 나중에 오프라인 상태시에도 확인할 수 있어야함 )
      await file.copy(imagePath);
      // Firestore 업로드
      await _firebaseStorage.putFile(file);
    }
    // MARK: - Post 모델 확정하기 => toJson으로 firestore 업로드 / 작성하기
    await _firestore.collection('posts').doc().set({});
  }
}
