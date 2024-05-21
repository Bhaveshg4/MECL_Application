// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mecl_application_1/pages/login.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Icon(Icons.login, color: Colors.white),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 28,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "Powered by MECL, Nagpur",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Image.asset(
                  "assets/message.png",
                  height: 350,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Your Intelligent\nCompanion",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Text(
                    "Your Personal Chatbot: Ready to Assist, Day or Night. Bringing You Quick Answers and Friendly Conversations.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                    child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 8, 56, 78)),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
