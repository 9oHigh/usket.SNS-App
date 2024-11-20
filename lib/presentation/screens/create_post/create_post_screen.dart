import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/presentation/screens/create_post/provider/create_post_notifier_provider.dart';

class CreatePostScreen extends ConsumerWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createPostNotifierProvider);
    final notifier = ref.read(createPostNotifierProvider.notifier);

    void showPermissionDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('권한 요청'),
          content: const Text('갤러리 접근 권한이 필요합니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }

    Future<void> pickImage() async {
      final status = await Permission.photos.request();

      if (!status.isGranted) {
        showPermissionDialog(context);
        return;
      }

      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        notifier.updateSelectedImage(File(image.path));
      }
    }

    void handleUpload() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: main_color,
          ),
        ),
      );
      try {
        await notifier.uploadPost();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('게시물이 업로드되었습니다!'),
            backgroundColor: main_color,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
            backgroundColor: main_color,
          ),
        );
      } finally {
        context.pop(true);
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: main_color,
        title: const Text(
          '게시물 작성',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                  image: state.selectedImage != null
                      ? DecorationImage(
                          image: FileImage(state.selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: state.selectedImage == null
                    ? const Center(
                        child: Text('이미지 선택',
                            style: TextStyle(color: Colors.black54)),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: notifier.updateContent,
              maxLines: 5,
              minLines: 1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                focusColor: Colors.grey,
                labelText: '내용을 입력해주세요.',
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: main_color,
                        maximumSize:
                            Size(MediaQuery.of(context).size.width, 50)),
                    onPressed: handleUpload,
                    child: const Text(
                      '작성 완료',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
