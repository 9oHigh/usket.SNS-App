import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/constants/sizes.dart';
import 'package:sns_app/presentation/screens/create_post/provider/create_post_notifier_provider.dart';
import 'package:sns_app/presentation/widgets/custom_appbar.dart';

class CreatePostSecondScreen extends ConsumerWidget {
  const CreatePostSecondScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                createPostNotifier.uploadPost(createPostState.selectedImages!);
              },
              child: Padding(
                padding: EdgeInsets.only(right: getWidth(context) * 0.05),
                child: const Text('완료',
                    style: TextStyle(color: main_color, fontSize: 20)),
              ))
        ],
        titleText: 'New Post',
        titleAlign: MainAxisAlignment.center,
        titleColor: main_color,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            width: getWidth(context),
            height: getWidth(context),
            child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ),
                itemCount: createPostState.selectedImages!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(getWidth(context) * 0.05),
                    child: _photoWidget(createPostState.selectedImages![index],
                        getWidth(context).toInt(), builder: (data) {
                      return Image.memory(data, fit: BoxFit.cover);
                    }),
                  );
                }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.05),
            child: SizedBox(
              width: getWidth(context),
              height: getHeight(context) * 0.3,
              child: TextField(
                maxLines: 100,
                decoration: const InputDecoration(
                    hintText: "글을 작성하세요",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: main_color)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: main_color))),
                onChanged: (value) => createPostNotifier.updateContent(value),
              ),
            ),
          )
        ],
      )),
    );
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
