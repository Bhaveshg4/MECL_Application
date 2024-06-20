// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mecl_application_1/pages/SearchViaImage.dart';
import 'package:mecl_application_1/pages/homepage.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({super.key});

  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.9),
              ),
              SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Choose Action",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.9),
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.0,
                            ),
                          ),
                          child: Form(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 30),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomePage(),
                                      ),
                                    );
                                  },
                                  child: TextFormField(
                                    obscureText: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      hintText: "Text Chatbot",
                                      hintStyle: const TextStyle(
                                          color: Colors.white70),
                                      prefixIcon: const Icon(
                                          Icons.text_fields_rounded,
                                          color: Colors.white),
                                      suffixIcon: const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.white),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.3),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SearchViaImage(),
                                      ),
                                    );
                                  },
                                  child: TextFormField(
                                    obscureText: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      hintText: "Image Chatbot",
                                      hintStyle: const TextStyle(
                                          color: Colors.white70),
                                      prefixIcon: const Icon(Icons.image,
                                          color: Colors.white),
                                      suffixIcon: const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.white),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.3),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  obscureText: true,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: "PDF Chatbot",
                                    hintStyle:
                                        const TextStyle(color: Colors.white70),
                                    prefixIcon: const Icon(
                                        Icons.picture_as_pdf_rounded,
                                        color: Colors.white),
                                    suffixIcon: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.3),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
