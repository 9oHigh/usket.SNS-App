import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/data/models/user_model.dart';
import 'package:sns_app/presentation/screens/profile/provider/profile_notifier_provider.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _profileImageUrlController;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.nickname);
    _profileImageUrlController =
        TextEditingController(text: widget.user.profileImageUrl);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _profileImageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _profileImageUrlController.text = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileNotifier = ref.read(profileNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_selectedImage != null)
              CircleAvatar(
                backgroundImage: FileImage(_selectedImage!),
                radius: 50,
              )
            else
              CircleAvatar(
                backgroundImage: NetworkImage(widget.user.profileImageUrl),
                radius: 50,
              ),
            TextButton(
              onPressed: _pickImage,
              child: const Text('Change Profile Picture'),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                profileNotifier.updateUserProfile(
                  _usernameController.text,
                  _profileImageUrlController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
