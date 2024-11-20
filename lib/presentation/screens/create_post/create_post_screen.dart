import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/presentation/screens/create_post/provider/create_post_notifier_provider.dart';

class CreatePostScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createPostNotifierProvider);
    final notifier = ref.read(createPostNotifierProvider.notifier);

    void _showPermissionDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('권한 요청'),
          content: Text('갤러리 접근 권한이 필요합니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인'),
            ),
          ],
        ),
      );
    }

    Future<void> _pickImage() async {
      final status = await Permission.photos.request();

      if (!status.isGranted) {
        _showPermissionDialog(context);
        return;
      }

      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        notifier.updateSelectedImage(File(image.path));
      }
    }

    void _handleUpload() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        await notifier.uploadPost();

        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('게시물이 업로드되었습니다!')),
        );
      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('업로드에 실패했습니다: $e')),
        );
      } finally {
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: main_color,
        title: Text('게시물 작성'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        actions: [
          TextButton(
            onPressed: _handleUpload,
            child: Text('완료', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
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
                    ? Center(
                        child: Text('이미지를 선택하세요',
                            style: TextStyle(color: Colors.black54)),
                      )
                    : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: notifier.updateContent,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusColor: Colors.black,
                labelText: '내용을 입력하세요',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
