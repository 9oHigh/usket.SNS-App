import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/core/manager/shared_preferences_manager.dart';
import 'package:sns_app/presentation/screens/profile/provider/profile_notifier_provider.dart';
import 'dart:io';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

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
        centerTitle: true,
        title: const Text(
          '프로필 수정',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            context.pop();
          },
        ),
        backgroundColor: main_color,
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
            const SizedBox(height: 16),
            TextField(
              controller: _nicknameController
                ..text = profileState.user?.nickname ?? '',
              decoration: const InputDecoration(labelText: '닉네임'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController..text = profileState.user?.bio ?? '',
              decoration: const InputDecoration(labelText: '자기소개'),
            ),
            const SizedBox(height: 16),
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
                    onPressed: () async {
                      await profileNotifier.updateProfile(
                        nickname: _nicknameController.text,
                        bio: _bioController.text,
                        imageFile: _imageFile,
                      );
                      SharedPreferenceManager().setPref<String>(
                          PrefsType.nickname, _nicknameController.text);
                      context.pop();
                    },
                    child: const Text(
                      '변경하기',
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
