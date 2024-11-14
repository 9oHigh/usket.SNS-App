import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:sns_app/presentation/screens/create_post/provider/create_post_notifier_provider.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final createPostState = ref.watch(createPostNotifierProvider);
    final createPostNotifier = ref.read(createPostNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(hintText: 'Write something...'),
            ),
            const SizedBox(height: 10),
            createPostState.image == null
                ? const Text('No image selected.')
                : Image.file(createPostState.image!, height: 200),
            ElevatedButton(
              onPressed: () async {
                final pickedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  createPostNotifier.setImage(File(pickedImage.path));
                }
              },
              child: const Text('Pick Image'),
            ),
            const Spacer(),
            createPostState.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      createPostNotifier.uploadPost(_captionController.text);
                      Navigator.pop(context);
                    },
                    child: const Text('Post'),
                  ),
          ],
        ),
      ),
    );
  }
}
