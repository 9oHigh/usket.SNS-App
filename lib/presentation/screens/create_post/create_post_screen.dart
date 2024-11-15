import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/constants/sizes.dart';
import 'dart:io';
import 'package:sns_app/presentation/screens/create_post/provider/create_post_notifier_provider.dart';
import 'package:sns_app/presentation/widgets/custom_appbar.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();

  List<AssetEntity> _mediaList = []; // 사진, 비디오 목록
  bool _isLoading = true; // 로딩 상태 확인

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    // 권한 요청
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      // 권한이 승인되었을 경우
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image, // image, video 또는 all
      );
      if (albums.isNotEmpty) {
        List<AssetEntity> media =
            await albums[0].getAssetListPaged(page: 0, size: 50);
        setState(() {
          _mediaList = media;
          _isLoading = false;
        });
      } else {
        // 앨범이 없을 경우
        setState(() {
          print('앨범이 없습니다');
          _isLoading = false;
        });
      }
    } else {
      // 권한이 거부되었을 경우
      setState(() {
        print('권한이 없습니다');
        _isLoading = false;
      });
      PhotoManager.openSetting(); // 설정 화면으로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    final createPostState = ref.watch(createPostNotifierProvider);
    final createPostNotifier = ref.read(createPostNotifierProvider.notifier);
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: main_color,
      appBar: const CustomAppbar(
        titleText: 'New Post',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: _mediaList.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<Widget>(
                    future: _mediaList[index]
                        .thumbnailDataWithSize(const ThumbnailSize(200, 200))
                        .then(
                          (data) => Image.memory(data!, fit: BoxFit.cover),
                        ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return snapshot.data!;
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                },
              ),
      ),
    );
  }
}
