import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;

  void _uploadPhoto() async {
    final selectedPhotoFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
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

    if (_selectedPhoto != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_photo')
          .child(user.uid)
          .child(Uuid().v1());

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

  Future<void> _convertToText() async {
    if (!_isListening) {
      bool hasSpeech = await _speech.initialize();
      if (hasSpeech) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _controller.text = val.recognizedWords;
            _enteredMessage = val.recognizedWords;
            if(val.finalResult) {
              _isListening = false;
            }
          }),
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 5),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
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
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Send a message...',
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      onPressed: _uploadPhoto,
                      icon: const Icon(
                        Icons.photo_album,
                        size: 20,
                      ),
                      color: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      constraints: const BoxConstraints(),
                    ),
                    IconButton(
                      onPressed: _convertToText,
                      icon: Icon(
                        Icons.mic,
                        size: 20,
                      ),
                      color: _isListening ? Colors.red : Colors.blue,
                      padding: const EdgeInsets.only(left: 4, right: 12),
                      constraints: const BoxConstraints(),
                    ),
                  ],
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
            onPressed: _enteredMessage.trim().isEmpty && _selectedPhoto == null
                ? null
                : _sendMessage,
            icon: const Icon(Icons.send),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
