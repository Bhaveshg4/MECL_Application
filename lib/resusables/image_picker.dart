// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImagePickerUploader extends StatefulWidget {
  final Function(String) onExtractedText;

  const ImagePickerUploader({required this.onExtractedText, super.key});

  @override
  _ImagePickerUploaderState createState() => _ImagePickerUploaderState();
}

class _ImagePickerUploaderState extends State<ImagePickerUploader> {
  File? _image;
  String? _downloadUrl;
  String? _extractedText;

  Future<void> _pickImage() async {
    if (await Permission.photos.request().isGranted ||
        await Permission.storage.request().isGranted) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        _uploadImage();
      }
    } else {
      print("Storage permission denied");
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      String fileName = _image!.path.split('/').last;
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('uploads/$fileName');
      UploadTask uploadTask = ref.putFile(_image!);

      TaskSnapshot snapshot = await uploadTask;
      _downloadUrl = await snapshot.ref.getDownloadURL();

      _extractText(_downloadUrl);

      setState(() {
        _downloadUrl = _downloadUrl;
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _extractText(String? downloadUrl) async {
    if (downloadUrl == null) return;

    try {
      final Uri encodedUrl = Uri.parse(
          'http://192.168.1.6:5000/extract_text?q=${Uri.encodeComponent(downloadUrl)}');
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
        if (_image == null && _downloadUrl == null)
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
                      onPressed: _pickImage,
                    ),
                    const Text(
                      "Upload Image here",
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
        if (_image != null && _downloadUrl == null)
          const CircularProgressIndicator(
            color: Colors.blue,
          ),
        if (_downloadUrl != null)
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(_downloadUrl!),
            ),
          )
      ],
    );
  }
}
