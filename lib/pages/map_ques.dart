import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class MapQuestionsPage extends StatefulWidget {
  const MapQuestionsPage({super.key});

  @override
  State<MapQuestionsPage> createState() => _MapQuestionsPageState();
}

class _MapQuestionsPageState extends State<MapQuestionsPage> {
  final TextEditingController _textEditingController = TextEditingController();

  late String _imageAnomaly = "";
  late Uint8List _imageBytesAnomaly2d;
  late Uint8List _imageBytesAnomaly3d;
  late Uint8List _imageBytesContour2d;
  late Uint8List _imageBytesContour3d;

  String? ipAddress;

  @override
  void initState() {
    setState(() {
      _imageBytesContour2d = Uint8List(0);
      _imageBytesContour3d = Uint8List(0);
      _imageBytesAnomaly2d = Uint8List(0);
      _imageBytesAnomaly3d = Uint8List(0);
    });

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

  Future<void> _fetchImage(String element) async {
    await _fetchImageContour(element);
    final response = await http.get(
      Uri.parse('http://$ipAddress:5000/plot_contour?element=$element'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String base64String = data['plot'];
      setState(() {
        _imageAnomaly = base64String;
        _imageBytesAnomaly2d = base64Decode(base64String);
      });
    }
  }

  Future<void> _fetchImageContour(String element) async {
    await _fetchImageAnomaly3d(element);
    final response = await http.get(
      Uri.parse('http://$ipAddress:5000/plot_anomaly?element=$element'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String base64String = data['plot'];
      setState(() {
        _imageBytesContour2d = base64Decode(base64String);
      });
    }
  }

  Future<void> _fetchImageAnomaly3d(String element) async {
    await _fetchImageContour3d(element);
    final response = await http.get(
      Uri.parse('http://$ipAddress:5000/plot_anomaly_3d?element=$element'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String base64String = data['plot'];
      setState(() {
        _imageBytesAnomaly3d = base64Decode(base64String);
      });
    }
  }

  Future<void> _fetchImageContour3d(String element) async {
    final response = await http.get(
      Uri.parse('http://$ipAddress:5000/plot_3d_contour?element=$element'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String base64String = data['plot'];
      setState(() {
        _imageBytesContour3d = base64Decode(base64String);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Map Bot'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _imageAnomaly.isEmpty
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: Card(
                                color: Colors.grey.shade200,
                                borderOnForeground: true,
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "Enter Element Name to generate Anomaly & Contour Map.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: Card(
                                color: Colors.grey.shade200,
                                borderOnForeground: true,
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "Additional Statistical data is also given for Reference.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            Image.memory(_imageBytesContour2d),
                            Image.memory(_imageBytesContour3d),
                            Image.memory(_imageBytesAnomaly2d),
                            Image.memory(_imageBytesAnomaly3d),
                          ],
                        ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _textEditingController,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Type your question...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final element = _textEditingController.text.trim();
                    if (element.isNotEmpty) {
                      _fetchImage(element);
                    }
                  },
                  icon: const Icon(Icons.send),
                  color: Colors.white,
                  iconSize: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}








// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class MapQuestionsPage extends StatefulWidget {
//   const MapQuestionsPage({super.key});

//   @override
//   State<MapQuestionsPage> createState() => _MapQuestionsPageState();
// }

// class _MapQuestionsPageState extends State<MapQuestionsPage> {
//   final TextEditingController _textEditingController = TextEditingController();

//   late String _imageContour = "";
//   late String _imageAnomaly = "";

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text('Map Bot'),
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//         elevation: 5,
//         shadowColor: Colors.grey,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   _imageAnomaly.isEmpty || _imageContour.isEmpty
//                       ? Column(
//                           children: [
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.95,
//                               child: Card(
//                                 color: Colors.grey.shade200,
//                                 borderOnForeground: true,
//                                 child: const Padding(
//                                   padding: EdgeInsets.all(10.0),
//                                   child: Text(
//                                     "Enter Element Name to generate Anomaly & Contour Map.",
//                                     style: TextStyle(fontSize: 16),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.95,
//                               child: Card(
//                                 color: Colors.grey.shade200,
//                                 borderOnForeground: true,
//                                 child: const Padding(
//                                   padding: EdgeInsets.all(10.0),
//                                   child: Text(
//                                     "Additional Statistical data is also given for Reference.",
//                                     style: TextStyle(fontSize: 16),
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ],
//                         )
//                       : const Column(
//                           children: [],
//                         ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: TextField(
//                         controller: _textEditingController,
//                         style: const TextStyle(
//                           fontSize: 18,
//                         ),
//                         decoration: const InputDecoration(
//                           hintText: 'Type your question...',
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(Icons.send),
//                   color: Colors.white,
//                   iconSize: 30,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
