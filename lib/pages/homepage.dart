// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mecl_application_1/pages/SearchViaImage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<Message> _messages = [];
  bool _showDefaultMessage = true;

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

      final response =
          await http.get(Uri.parse('http://192.168.1.6:5000/ask?q=$message'));

      // String context =
      //     "The Ministry of Mines, New Delhi, on the 17th of August, 2023, issued Notification S.0. 3684(E) in\naccordance with the powers vested by sub-section (2) of section 1 of the Mines and Minerals\n(Development and Regulation) Amendment Act, 2023 (16 of 2023). Through this notification, the\nCentral Government formally appoints the 17th day of August, 2023 as the effective date for the\nimplementation of the said Act. This decision is made with the authority granted to the Central\nGovernment in matters concerning the regulation and development of mines and minerals. The\nnotification is signed by Dr. Veena Kumari Dermal, Joint Secretary, Ministry of Mines, under the\nreference number F. No. M.VI-1/3/2022-MVI.";

      // final response = await http.get(Uri.parse(
      //     "http://192.168.1.6:5000/question_image?q=$message&context=$context"));

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
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchViaImage()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(255, 36, 142, 230),
                      Color.fromARGB(255, 179, 96, 228)
                    ]),
                    border: Border.all(color: Colors.amber),
                    borderRadius: BorderRadius.circular(20)),
                height: 45,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Search via Image"),
                      SizedBox(
                        width: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        title: const Text(
          "MECL ChatBot",
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

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 280.0,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: message.isUser ? Colors.grey.shade700 : Colors.blue.shade400,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.content.trim(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
