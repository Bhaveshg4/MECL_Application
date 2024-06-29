// ignore_for_file: file_names, depend_on_referenced_packages, library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:mecl_application_1/resusables/pdf_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchViaPDF extends StatefulWidget {
  const SearchViaPDF({super.key});

  @override
  State<SearchViaPDF> createState() => _SearchViaPDFState();
}

class _SearchViaPDFState extends State<SearchViaPDF> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<Message> _messages = [];

  String? contextString = "";
  String? ipAddress;

  @override
  void initState() {
    getCurrentIP();
    super.initState();
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
    if (message.isNotEmpty && contextString!.isNotEmpty) {
      setState(() {
        _messages.add(Message(content: message, isUser: true));
        _textEditingController.clear();
      });

      final response = await http.get(Uri.parse(
          "http://$ipAddress:5000/question_image?q=$message&context=$contextString"));

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
    } else {
      showErrorDialog("Write Question or upload image");
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(fontSize: 18.0),
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 18.0),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Ok',
                style: TextStyle(fontSize: 18.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void handleExtractedText(String text) {
    setState(() {
      contextString = text;
    });

    print("Context: ${contextString!}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PDF ChatBot",
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
          children: [
            const SizedBox(height: 20),
            PdfPickerUploader(
              onExtractedText: handleExtractedText,
            ),
            const SizedBox(height: 20),
            const Divider(
              indent: 8.0,
              endIndent: 8.0,
              thickness: 2.5,
            ),
            Expanded(
              child: ListView.builder(
                reverse: false,
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
