// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<Message> _messages = [];
  bool _showDefaultMessage = true;

  String? ipAddress;

  @override
  void initState() {
    super.initState();
    getCurrentIP();
  }

  Future<String> getCurrentIP({String defaultIP = '192.168.1.1'}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ipAddress = prefs.getString("currentIP");
    });
    return prefs.getString('currentIP') ?? defaultIP;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String message) async {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(Message(content: message, isUser: true));
        _textEditingController.clear();
        _showDefaultMessage = false;
      });

      String url;
      if (kIsWeb) {
        url = "http://$ipAddress:5000";
      } else {
        url = "$ipAddress:5000";
      }

      final uri = Uri.http(url, '/ask', {'q': message});
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _messages.add(Message(content: "${data['response']}", isUser: false));
        });
      } else {
        setState(() {
          _messages
              .add(Message(content: "Error fetching response", isUser: false));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Text ChatBot",
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            if (_showDefaultMessage)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 131, 130, 231)
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Text(
                    '1. Try asking "What is MECL?"\n\n2. Try asking "When was MECL founded?"',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            if (_showDefaultMessage)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Text(
                  'The AI tool is made for informative purpose, please refrain from misusing it. The chat output maybe incorrect, provided incorrect context.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            Expanded(
              child: ListView.builder(
                reverse: false,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return MessageBubble(message: message);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          controller: _textEditingController,
                          onSubmitted: _sendMessage,
                          onChanged: (_) {
                            setState(() {
                              _showDefaultMessage = false;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Type your question...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _sendMessage(_textEditingController.text),
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String content;
  final bool isUser;

  Message({required this.content, required this.isUser});
}

class MessageBubble extends StatelessWidget {
  final Message message;
  // final FlutterTts flutterTts = FlutterTts();

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: Platform.isWindows
            ? BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
                minWidth: MediaQuery.of(context).size.width * 0.1,
              )
            : const BoxConstraints(
                maxWidth: 280.0,
              ),
        child: GestureDetector(
          onTap: () {
            if (!message.isUser) {
              _speakMessage(message.content);
            }
          },
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? Colors.grey.shade700
                      : Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.content.trim(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    if (!message.isUser)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Icon(
                          Icons.volume_up,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _speakMessage(String message) async {
    // await flutterTts.setLanguage("en-US");
    // await flutterTts.setPitch(1.0);
    // await flutterTts.speak(message);
  }
}
