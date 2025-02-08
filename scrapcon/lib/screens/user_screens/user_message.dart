import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

void main() {
  runApp(ChatScreen());
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<types.Message> _messages = [];
  final types.User _user = types.User(id: "1");
  final types.User _otherUser = types.User(id: "2");

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
                Text("+91-9825782698", style: TextStyle(fontSize: 12, color: Colors.grey)),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "My Ads"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Activity"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Account"),
        ],
      ),
    );
  }
}
