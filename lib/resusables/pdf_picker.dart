// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PdfPickerUploader extends StatefulWidget {
  final Function(String) onExtractedText;

  const PdfPickerUploader({required this.onExtractedText, super.key});

  @override
  _PdfPickerUploaderState createState() => _PdfPickerUploaderState();
}

class _PdfPickerUploaderState extends State<PdfPickerUploader> {
  File? _pdf;
  String? _downloadUrl;
  String? _extractedText;
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

  Future<void> _pickPdf() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      final result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
      if (result != null && result.files.single.path != null) {
        setState(() {
          _pdf = File(result.files.single.path!);
        });
        _uploadPdf();
      }
    } else {
      print("Storage permission denied");
    }
  }

  Future<void> _uploadPdf() async {
    if (_pdf == null) return;

    try {
      String fileName = _pdf!.path.split('/').last;
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('uploads/$fileName');
      UploadTask uploadTask = ref.putFile(_pdf!);

      TaskSnapshot snapshot = await uploadTask;
      _downloadUrl = await snapshot.ref.getDownloadURL();

      _extractText(_downloadUrl);

      setState(() {
        _downloadUrl = _downloadUrl;
      });
    } catch (e) {
      print('Error uploading PDF: $e');
    }
  }

  Future<void> _extractText(String? downloadUrl) async {
    if (downloadUrl == null) {
      print("Error Here");
      return;
    }

    try {
      final Uri encodedUrl = Uri.parse(
          'http://$ipAddress:5000/extract_pdf_text?q=${Uri.encodeComponent(downloadUrl)}');
      final response = await http.get(encodedUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _extractedText = data['response'];
        });
        widget.onExtractedText(_extractedText!);
      } else {
        print('Error extracting text: ${response.statusCode}');
      }
    } catch (e) {
      print('Error extracting text: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_pdf == null && _downloadUrl == null)
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.97,
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.file_upload),
                      iconSize: 45,
                      onPressed: _pickPdf,
                    ),
                    const Text(
                      "Upload PDF here",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (_pdf != null && _downloadUrl == null)
          const CircularProgressIndicator(
            color: Colors.blue,
          ),
        if (_downloadUrl != null)
          Column(
            children: [
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 80.0,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "PDF uploaded successfully",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
      ],
    );
  }
}
