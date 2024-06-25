import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final user = FirebaseAuth.instance.currentUser;
  List<types.Message> _messages = [];
  types.User _user = const types.User(id: 'user_id');
  final types.User _bot = const types.User(id: 'bot_id');

  final _uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    _user = types.User(
        id: user!.uid, firstName: user!.displayName, imageUrl: user!.photoURL);
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot')),
      body: Chat(
        showUserAvatars: true,
        showUserNames: true,
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: _uuid.v4(),
      text: message.text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });

    _sendMessageToBot(message.text);
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
          text: data['choices'][0]['text'].trim(),
        );

        setState(() {
          _messages.insert(0, botMessage);
        });
      } else {
        print('Failed to load response: ${response.statusCode}');
        print('Response body: ${response.body}');
        _showErrorMessage('Failed to load response from the server.');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorMessage('An error occurred while sending the message.');
    }
  }

  void _showErrorMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
