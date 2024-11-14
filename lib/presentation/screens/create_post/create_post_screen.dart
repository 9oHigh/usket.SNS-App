import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:sns_app/presentation/screens/create_post/provider/create_post_notifier_provider.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  File? _image;
  final TextEditingController _captionController = TextEditingController();

  Future<void> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> uploadPost() async {
    if (_image != null && _captionController.text.isNotEmpty) {
      final createPostNotifier = ref.read(createPostNotifierProvider.notifier);
      await createPostNotifier.uploadPost(
        "YOUR_USER_ID",
        "YOUR_USERNAME",
        "YOUR_PROFILE_IMAGE_URL",
        _captionController.text,
        _image!,
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(createPostNotifierProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _captionController,
              decoration: InputDecoration(hintText: 'Write something...'),
            ),
            SizedBox(height: 10),
            _image == null
                ? Text('No image selected.')
                : Image.file(_image!, height: 200),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick Image'),
            ),
            Spacer(),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: uploadPost,
                    child: Text('Post'),
                  ),
          ],
        ),
      ),
    );
  }
}
