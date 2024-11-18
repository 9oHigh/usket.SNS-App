import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sns_app/presentation/screens/create_post/provider/state/create_post_state.dart';

class CreatePostNotifier extends StateNotifier<CreatePostState> {
  CreatePostNotifier() : super(CreatePostState(mode: Mode.SINGLE));

  void loadPhotos() async {
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
        album: album,
        headerText: album.first.name,
        imageList: imageList,
        selectedImages: [imageList.first],
        previewImage: imageList.first,
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
    }
    state = state.copyWith(selectedImages: selectedImages);
  }

  void updateContent(String content) {
    state = state.copyWith(content: content);
  }

  void uploadPost(List<AssetEntity> assets) async {
    for (int n = 0; n < assets.length; n++) {
      final thumbnail =
          await assets[n].thumbnailDataWithSize(const ThumbnailSize(200, 200));
      final buffer = thumbnail!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();

      final filePath = '${tempDir.path}/${basename(assets[n].title!)}';
      final file = File(filePath)..writeAsBytesSync(buffer);

      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('images/${basename(file.path)}');
        await storageRef.putFile(file);
        print('Upload complete');
      } catch (e) {
        print('Upload failed: $e');
      }
    }
  }
}
