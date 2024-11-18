import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/constants/sizes.dart';
import 'package:sns_app/presentation/screens/create_post/provider/create_post_notifier_provider.dart';
import 'package:sns_app/presentation/screens/create_post/provider/state/create_post_state.dart';
import 'package:sns_app/presentation/widgets/custom_appbar.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(createPostNotifierProvider.notifier).loadPhotos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final createPostState = ref.watch(createPostNotifierProvider);
    final createPostNotifier = ref.read(createPostNotifierProvider.notifier);

    return Scaffold(
      appBar: CustomAppbar(
        leading: true,
        leadingColor: Colors.grey,
        leadingEvent: () {
          GoRouter.of(context).pop();
        },
        actions: [
          GestureDetector(
              onTap: () {
                GoRouter.of(context).push('/createPostSecond');
              },
              child: Padding(
                padding: EdgeInsets.only(right: getWidth(context) * 0.05),
                child: const Text('다음',
                    style: TextStyle(color: main_color, fontSize: 20)),
              ))
        ],
        titleText: 'New Post',
        titleAlign: MainAxisAlignment.center,
        titleColor: main_color,
      ),
      body: SingleChildScrollView(
          child: Center(
        child: createPostState.album != null &&
                createPostState.previewImage != null
            ? Column(
                children: [
                  _preview(createPostState.previewImage!),
                  _header(createPostState.headerText, createPostState,
                      createPostNotifier),
                  _imageSelectWidget(
                      createPostState.imageList,
                      createPostState.selectedImages!,
                      createPostState,
                      createPostNotifier),
                ],
              )
            : const CircularProgressIndicator(),
      )),
    );
  }

  Widget _preview(AssetEntity asset) {
    return SizedBox(
      width: getWidth(context),
      height: getWidth(context),
      child: _photoWidget(asset, getWidth(context).toInt(), builder: (data) {
        return Image.memory(data, fit: BoxFit.cover);
      }),
    );
  }

  Widget _header(
      String headerText, CreatePostState createPostState, createPostNotifier) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getWidth(context) * 0.05,
            vertical: getHeight(context) * 0.01),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Text(headerText, style: const TextStyle(fontSize: 20)),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  createPostNotifier.updateMode(createPostState.mode);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: createPostState.mode == Mode.SINGLE
                          ? sub_color
                          : main_color),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.copy,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              )
            ],
          )
        ]));
  }

  Widget _imageSelectWidget(
      List<AssetEntity> imageList,
      List<AssetEntity> selectedImages,
      CreatePostState createPostState,
      createPostNotifier) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1),
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          return _photoWidget(imageList[index], (getWidth(context) / 4).toInt(),
              builder: (data) {
            return GestureDetector(
              onTap: () {
                createPostState.mode == Mode.SINGLE
                    ? createPostNotifier.updatePreviewImage(imageList[index])
                    : createPostNotifier.updateSelectImages(imageList[index]);
              },
              child: Opacity(
                  opacity: selectedImages.contains(imageList[index]) ? 0.3 : 1,
                  child: Image.memory(data, fit: BoxFit.cover)),
            );
          });
        });
  }

  Widget _photoWidget(AssetEntity asset, int size,
      {required Widget Function(Uint8List) builder}) {
    return FutureBuilder(
        future: asset.thumbnailDataWithSize(ThumbnailSize(size, size)),
        builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            return builder(snapshot.data!);
          } else {
            return Container();
          }
        });
  }
}
