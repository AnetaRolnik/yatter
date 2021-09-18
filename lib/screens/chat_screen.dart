import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yatter'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) =>
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text('Message'),
            ),
        itemCount: 10,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/I5DRJn1Wjq0L38h3rRhn/messages')
              .snapshots()
              .listen((data) {
            data.docs.forEach((docs) {
              print(docs['text']);
            });
          });
        },
      ),
    );
  }
}
