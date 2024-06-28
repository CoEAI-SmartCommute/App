import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_commute/components/toast/toast.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:bubble/bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final List<types.Message> _messages = [];
  types.User _user = const types.User(id: 'user_id');
  final types.User _bot = const types.User(id: 'bot_id');
  final _uuid = const Uuid();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _user = types.User(
      id: user!.uid,
      firstName: user!.displayName,
      imageUrl: user!.photoURL,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Disha')),
      body: Column(
        children: [
          Expanded(
            child: Chat(
              showUserAvatars: true,
              showUserNames: true,
              messages: _messages,
              user: _user,
              // bubbleBuilder: _bubbleBuilder,
              onSendPressed: (types.PartialText message) {},
              customBottomWidget: _buildCustomInput(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubbleBuilder(
    Widget child, {
    required message,
    required nextMessageInGroup,
  }) =>
      Bubble(
        color: _user.id != message.author.id ||
                message.type == types.MessageType.image
            ? Colors.blue
            : Colors.grey,
        margin: nextMessageInGroup
            ? const BubbleEdges.symmetric(horizontal: 1)
            : null,
        nip: nextMessageInGroup
            ? BubbleNip.no
            : _user.id != message.author.id
                ? BubbleNip.leftBottom
                : BubbleNip.rightBottom,
        radius: const Radius.circular(20),
        child: DefaultTextStyle(
          style: TextStyle(
            color: _user.id == message.author.id ? Colors.white : Colors.white,
          ),
          child: child,
        ),
      );

  Widget _buildCustomInput() {
    return Container(
      padding: const EdgeInsets.only(bottom: 40, left: 8, right: 8),
      child: Row(
        children: [
          Expanded(
            child: Hero(
              tag: "searchBar",
              child: TextField(
                controller: _controller,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  fillColor: const Color(0xffE9E9E9),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  hintText: 'Hi! Where do you want to go?',
                  hintStyle: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                _handleSendPressed(_controller.text);
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  void _handleSendPressed(String text) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: _uuid.v4(),
      text: text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });

    _sendMessageToBot(text);
  }

  Future<void> _sendMessageToBot(String text) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['OPENAPIKEY']!}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'user',
              'content': text,
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final botMessage = types.TextMessage(
          author: _bot,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: _uuid.v4(),
          text: data['choices'][0]['message']['content'].trim(),
        );

        setState(() {
          _messages.insert(0, botMessage);
        });
      } else {
        _showErrorMessage('Failed to load response from the server.');
      }
    } catch (e) {
      _showErrorMessage('An error occurred while sending the message.');
    }
  }

  void _showErrorMessage(String message) {
    errorToast(message);
  }
}
