import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:sns_app/data/models/user_modle.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
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
    if (_image == null || _captionController.text.isEmpty) return;

    final uid = auth.FirebaseAuth.instance.currentUser!.uid;
    final postId = FirebaseFirestore.instance.collection('posts').doc().id;

    final imageUrl = await FirebaseStorage.instance
        .ref('posts/$postId.jpg')
        .putFile(_image!)
        .then((snapshot) => snapshot.ref.getDownloadURL());

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final user = User.fromDocument(userDoc);

    await FirebaseFirestore.instance.collection('posts').doc(postId).set({
      'postId': postId,
      'uid': uid,
      'username': user.username,
      'profileImageUrl': user.profileImageUrl,
      'imageUrl': imageUrl,
      'caption': _captionController.text,
      'likesCount': 0,
      'likes': [],
      'createdAt': Timestamp.now(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
            ElevatedButton(
              onPressed: uploadPost,
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
