import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/data/models/user_model.dart';
import 'package:sns_app/presentation/screens/create_post/provider/state/create_post_state.dart';
import 'package:uuid/uuid.dart';

class CreatePostNotifier extends StateNotifier<CreatePostState> {
  CreatePostNotifier() : super(CreatePostState()) {
    _loadPhotos();
  }

  PostModel? post;

  void _loadPhotos() async {
    var result = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> album = [];

    if (result.isAuth) {
      album = await PhotoManager.getAssetPathList(
          type: RequestType.image,
          filterOption: FilterOptionGroup(
            imageOption: const FilterOption(
              sizeConstraint: SizeConstraint(minWidth: 100, minHeight: 100),
            ),
            orders: [
              const OrderOption(type: OrderOptionType.createDate, asc: false)
            ],
          ));

      List<AssetEntity> imageList =
          await album.first.getAssetListRange(start: 0, end: 30);

      state = state.copyWith(
        mode: Mode.SINGLE,
        album: album,
        imageList: imageList,
        previewImage: imageList.first,
        selectedImages: [imageList.first],
        headerText: album.first.name,
        content: '',
      );
    }
  }

  void updateMode(Mode mode) {
    if (mode == Mode.SINGLE) {
      state = state.copyWith(mode: Mode.MULTI);
    } else {
      state = state.copyWith(mode: Mode.SINGLE);
    }
  }

  void updatePreviewImage(AssetEntity previewImage) {
    state = state
        .copyWith(selectedImages: [previewImage], previewImage: previewImage);
  }

  void updateSelectImages(AssetEntity selectedImage) {
    var selectedImages = state.selectedImages;
    if (selectedImages!.contains(selectedImage)) {
      selectedImages.remove(selectedImage);
    } else {
      selectedImages.add(selectedImage);
      state = state.copyWith(previewImage: selectedImage);
    }
    state = state.copyWith(selectedImages: selectedImages);
  }

  void updateContent(String content) {
    state = state.copyWith(content: content);
  }

  String makeFilePath() {
    return '${const Uuid().v4()}.jpg';
  }

  Future<void> uploadPost(List<AssetEntity> assets, UserModel userInfo) async {
    var file = await assets[0].file;
    var fileName = basename(file!.path);

    var task = uploadFile(
        file, '/${FirebaseAuth.instance.currentUser!.uid}/$fileName');

    try {
      task.snapshotEvents.listen((event) async {
        if (event.bytesTransferred == event.totalBytes &&
            event.state == TaskState.success) {
          var downloadUrl = await event.ref.getDownloadURL();
          print("Download URL: $downloadUrl");
          print(userInfo);
          var updatedPost = PostModel.init(userInfo).copyWith(
            thumbnail: downloadUrl,
          );
          await submitPost(updatedPost);
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  UploadTask uploadFile(File file, String filename) {
    var ref = FirebaseStorage.instance.ref().child('sns').child(filename);
    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});
    return ref.putFile(file, metadata);
  }

  Future<void> submitPost(PostModel postData) async {
    try {
      print('submit');
      await FirebaseFirestore.instance
          .collection('posts')
          .add(postData.toJson());
    } catch (e) {
      print("submitPost: ${e.toString()}");
    }
  }

  void resetState() {
    _loadPhotos(); // 초기 상태로 리셋
  }
}
