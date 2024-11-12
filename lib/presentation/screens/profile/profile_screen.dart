import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/presentation/screens/profile/provider/profile_notifier_provider.dart';
import 'package:sns_app/presentation/screens/profile/provider/state/profile_state.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerWidget {
  final String userId;

  ProfileScreen({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);
    final profileNotifier = ref.read(profileNotifierProvider.notifier);

    if (profileState.user == null && !profileState.isLoading) {
      Future.delayed(Duration.zero, () {
        profileNotifier.loadUserProfile(userId);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: profileState.isLoading
          ? Center(child: CircularProgressIndicator())
          : profileState.error.isNotEmpty
              ? Center(child: Text(profileState.error))
              : profileState.user != null
                  ? Column(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(profileState.user!.profileImageUrl),
                          radius: 50,
                        ),
                        SizedBox(height: 16),
                        Text(
                          profileState.user!.username,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(profileState.user!.bio),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  profileState.user!.posts.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("Posts"),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  profileState.user!.followers.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("Followers"),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  profileState.user!.following.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("Following"),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfileScreen(user: profileState.user!),
                              ),
                            );
                          },
                          child: Text('Edit Profile'),
                        ),
                      ],
                    )
                  : Center(child: Text("No profile information available")),
    );
  }
}

class EditProfileScreen extends ConsumerStatefulWidget {
  final User user;

  EditProfileScreen({required this.user});

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
    _usernameController = TextEditingController(text: widget.user.username);
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
        title: Text('Edit Profile'),
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
              child: Text('Change Profile Picture'),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                profileNotifier.updateUserProfile(
                  _usernameController.text,
                  _profileImageUrlController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
