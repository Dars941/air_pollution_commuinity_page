import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/comm_post.dart';
import '../utils/functions.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  final picker = ImagePicker();
  File? _imageFile;
  String? _imgUrl;

  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage(String id) async {
    try {
      if (_imageFile != null) {
        final storage = FirebaseStorage.instance;
        final ref = storage.ref().child('posts/$id');
        final uploadTask = ref.putFile(_imageFile!);
        final snapshot = await uploadTask.whenComplete(() {});
        _imgUrl = await snapshot.ref.getDownloadURL();
      }
    } catch (e) {
      rethrow;
    }
  }

  // upload post
  Future<void> _uploadPost() async {
    String msg = '';
    if (_titleController.text.isEmpty) {
      msg = 'Enter a title';
    } else if (_imageFile == null) {
      msg = 'Select an image';
    }
    if (msg.isNotEmpty) {
      showSnackBar(context, msg);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final id = const Uuid().v4();
      await _uploadImage(id);
      final firestore = FirebaseFirestore.instance;
      final post = Post(
        id: id,
        title: _titleController.text,
        description: _descriptionController.text,
        image: _imgUrl!,
        location: _locationController.text,
      );
      firestore
          .collection('posts')
          .doc(id)
          .set(post.toMap())
          .then((value) => Navigator.pop(context));
    } catch (e) {
      showSnackBar(context, e.toString());
      rethrow;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Post')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Title'),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Enter title',
            ),
          ),
          const SizedBox(height: 20),
          const Text('Description'),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'Enter description',
            ),
          ),
          const SizedBox(height: 20),
          const Text('Image'),
          _imageFile != null
              ? Image.file(
                  _imageFile!,
                  height: 200,
                  width: 200,
                )
              : TextButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
          const SizedBox(height: 20),
          const Text('Location'),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              hintText: 'Enter location',
            ),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _uploadPost,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Upload Post'),
          ),
        ],
      ),
    );
  }
}
