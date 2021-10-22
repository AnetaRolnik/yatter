import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble(this.message, this.isMe, this.username, this.userImage,
      this.createdAt, this.photo,
      {Key? key})
      : super(key: key);

  final String message;
  final bool isMe;
  final String username;
  final String userImage;
  final Timestamp createdAt;
  final String photo;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  var _isDate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      child: Row(
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isMe)
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userImage),
            ),
          if (!widget.isMe) const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() => _isDate = !_isDate);
                  if (_isDate) {
                    Timer(
                      const Duration(seconds: 3),
                      () => setState(() => _isDate = false),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.isMe
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 200,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (!widget.message.isEmpty)
                        Text(
                          widget.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      if (!widget.photo.isEmpty && !widget.message.isEmpty) SizedBox(height: 10),
                      if (!widget.photo.isEmpty)
                        Image(
                          image: NetworkImage(widget.photo),
                        ),
                    ],
                  ),
                ),
              ),
              if (_isDate) const SizedBox(height: 4),
              if (_isDate)
                Text(
                  DateFormat('kk:mm dd.MM.yyyy').format(
                    widget.createdAt.toDate(),
                  ),
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
