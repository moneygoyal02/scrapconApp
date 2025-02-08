import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<types.Message> _messages = [];
  final types.User _user = types.User(id: "1");
  // final types.User _otherUser = types.User(id: "2");

  void _handleSendPressed(types.PartialText message) {
    final newMessage = types.TextMessage(
      author: _user,
      id: const Uuid().v4(),
      text: message.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      _messages.insert(0, newMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF17255A),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Karan", style: TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
        actions: [
          Icon(Icons.more_vert),
          SizedBox(width: 10),
        ],
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        customBottomWidget: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFF17255A), width: 2.0),
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (text) {
                      if (text.isNotEmpty) {
                        _handleSendPressed(types.PartialText(text: text));
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0xFF17255A)),
                  onPressed: () {
                    // Add your send button logic here
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
