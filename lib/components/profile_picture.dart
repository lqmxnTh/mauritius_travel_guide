// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePictureWidget extends StatefulWidget {
  const ProfilePictureWidget({super.key});

  @override
  _ProfilePictureWidgetState createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  File? _imageFile;
  final String _imageKey = 'profile_image';

  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().getImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
      _saveProfilePicture();
    }
  }

  Future<void> _loadProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_imageKey);
    if (imagePath != null) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  Future<void> _saveProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    if (_imageFile != null) {
      await prefs.setString(_imageKey, _imageFile!.path);
    } else {
      await prefs.remove(_imageKey);
    }
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('View Profile Picture'),
              onTap: () {
                Navigator.pop(context);
                _viewProfilePicture(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  void _viewProfilePicture(BuildContext context) {
    if (_imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Image.file(_imageFile!),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showOptions(context),
      child: CircleAvatar(
        radius: 80,
        backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
        child: _imageFile == null
            ? const Icon(
          Icons.person,
          size: 80,
        )
            : null,
      ),
    );
  }
}
