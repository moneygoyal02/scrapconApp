import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatbotSupport extends StatefulWidget {
  @override
  _ChatbotSupportState createState() => _ChatbotSupportState();
}

class _ChatbotSupportState extends State<ChatbotSupport> {
  final ChatUser user = ChatUser(
    firstName: "User",
    id: "1",
  );

  final ChatUser bot = ChatUser(
    firstName: "Bot",
    id: "2",
  );

  List<ChatMessage> messages = [];

  Future<void> _sendMessage(ChatMessage message) async {
    setState(() {
      messages.add(message);
    });

    final response = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyCRxjSjJPnPGcTzpNa9XGM1k_nK1GHOtEE'), // Replace with the actual Gemini API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": message.text}
              ]
            }
          ]
        }));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      setState(() {
        messages.add(ChatMessage(
          text: data['candidates'][0]['content']['parts'][0]['text'],
          user: bot,
          createdAt: DateTime.now(),
        ));
      });
    } else {
      setState(() {
        messages.add(ChatMessage(
          text: 'Error: Unable to get response from the server.',
          user: bot,
          createdAt: DateTime.now(),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot Support'),
        backgroundColor: Color(0xFF17255A),
        foregroundColor: Colors.white,
      ),
      body: DashChat(
        currentUser: user,
        
        messages: messages,
        onSend: _sendMessage,
        inputOptions: InputOptions(
          inputDecoration: InputDecoration(
            hintText: 'Type a message',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          inputToolbarStyle: BoxDecoration(
            border: Border.all(color: Color(0xFF17255A)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        messageOptions: MessageOptions(
          messageDecorationBuilder:
              (ChatMessage msg, ChatMessage? prevMsg, ChatMessage? nextMsg) {
            return BoxDecoration(
              color: msg.user.id == user.id ? Color(0xFF17255A) : Color(0x79AAF0),
              borderRadius: BorderRadius.circular(10),
            );
          },
        ),
      ),
    );
  }
}
