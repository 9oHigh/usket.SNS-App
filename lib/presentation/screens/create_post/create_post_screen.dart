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
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Create a Post'),
        backgroundColor: Colors.grey[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight / 20,
            ),
            GestureDetector(
              onTap: () async {
                final pickedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  createPostNotifier.setImage(File(pickedImage.path));
                }
              },
              child: Container(
                height: screenHeight / 5,
                width: screenHeight / 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: createPostState.image == null
                    ? const Center(
                        child: Text(
                          'Pick Image',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          createPostState.image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextField(
                controller: _captionController,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Write something...',
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const Spacer(),
            createPostState.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (_captionController.text.isNotEmpty) {
                        createPostNotifier.uploadPost(_captionController.text);
                        Navigator.pop(context);
                      } else {
                        // MARK: - Alert Dialog or Snackbar
                      }
                    },
                    child: const Text('Post'),
                  ),
          ],
        ),
      ),
    );
  }
}
