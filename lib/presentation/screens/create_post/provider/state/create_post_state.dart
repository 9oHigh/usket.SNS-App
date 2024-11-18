import 'package:photo_manager/photo_manager.dart';

enum Mode { SINGLE, MULTI }

class CreatePostState {
  final Mode mode;
  final List<AssetPathEntity>? album;
  final List<AssetEntity> imageList;
  final AssetEntity? previewImage;
  final List<AssetEntity>? selectedImages;
  final String headerText;
  final String content;

  CreatePostState({
    this.mode = Mode.SINGLE,
    this.album,
    this.imageList = const [],
    this.previewImage,
    this.selectedImages,
    this.headerText = "",
    this.content = "",
  });

  CreatePostState copyWith({
    Mode? mode,
    List<AssetPathEntity>? album,
    List<AssetEntity>? imageList,
    AssetEntity? previewImage,
    List<AssetEntity>? selectedImages,
    String? headerText,
    String? content,
  }) {
    return CreatePostState(
      mode: mode ?? this.mode,
      album: album ?? this.album,
      imageList: imageList ?? this.imageList,
      previewImage: previewImage ?? this.previewImage,
      selectedImages: selectedImages ?? this.selectedImages,
      headerText: headerText ?? this.headerText,
      content: content ?? this.content,
    );
  }
}
