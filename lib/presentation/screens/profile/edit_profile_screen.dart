import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sns_app/presentation/screens/profile/provider/profile_notifier_provider.dart';
import 'dart:io';

class EditProfileScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nicknameController = TextEditingController();
  final _bioController = TextEditingController();
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileNotifier = ref.read(profileNotifierProvider.notifier);
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : NetworkImage(profileState.user?.profileImageUrl ?? '')
                        as ImageProvider,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nicknameController
                ..text = profileState.user?.nickname ?? '',
              decoration: InputDecoration(labelText: 'Nickname'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bioController..text = profileState.user?.bio ?? '',
              decoration: InputDecoration(labelText: 'Bio'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await profileNotifier.updateProfile(
                  nickname: _nicknameController.text,
                  bio: _bioController.text,
                  imageFile: _imageFile,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
