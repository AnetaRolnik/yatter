import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/messages.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yatter'),
        actions: <Widget>[
          DropdownButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: const <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
                value: 'logout',
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Column(
        children: const <Widget>[
          Expanded(child: Messages()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/I5DRJn1Wjq0L38h3rRhn/messages')
              .add({'text': 'New message'});
        },
      ),
    );
  }
}
