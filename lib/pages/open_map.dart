import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SampleMapPage extends StatefulWidget {
  const SampleMapPage({super.key});

  @override
  State<SampleMapPage> createState() => _SampleMapPageState();
}

class _SampleMapPageState extends State<SampleMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "NGDR Map",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: const WebView(
        initialUrl: "https://mecl-chatbot.web.app/map_1.html",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
