import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({Key? key}) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final pickedImageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          backgroundImage: _pickedImage == null ? null : FileImage(_pickedImage!),
        ),
        TextButton(
          onPressed: _pickImage,
          child: const Text('Add Photo'),
        ),
      ],
    );
  }
}
