import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enteredMessage = '';
  var _urlPhoto = '';
  File? _selectedPhoto;

  void _uploadPhoto() async {
    final selectedPhotoFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      imageQuality: 80,
    );
    setState(() {
      _selectedPhoto = File(selectedPhotoFile!.path);
      _controller.text = _selectedPhoto!.path.split('/').last;
    });
  }

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if(_selectedPhoto != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_photo')
          .child(user.uid)
          .child(_selectedPhoto!.path.split('/').last);

      await ref.putFile(_selectedPhoto!);
      _urlPhoto = await ref.getDownloadURL();
    }

    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'photo': _urlPhoto,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    });
    _controller.clear();
    setState(() {
      _enteredMessage = '';
      _urlPhoto = '';
      _selectedPhoto = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Send a message...',
                prefixIcon: IconButton(
                  onPressed: _uploadPhoto,
                  icon: const Icon(Icons.photo_album),
                  color: Colors.blue,
                ),
              ),
              autocorrect: true,
              enableSuggestions: true,
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty && _selectedPhoto == null ? null : _sendMessage,
            icon: const Icon(Icons.send),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
