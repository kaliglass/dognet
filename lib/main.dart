import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'classifier.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.lightBlue[800],
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Classifier classifier = Classifier();
  final picker = ImagePicker();
  var image;
  String dogBreed = "";
  String dogProb = "";
  bool isClassifierInitialized = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initializeClassifier();
  }

  Future<void> initializeClassifier() async {
    setState(() => isLoading = true);
    await classifier.init();
    setState(() {
      isClassifierInitialized = true;
      isLoading = false;
    });
  }

  Future<void> classifySelectedImage(File imageFile) async {
    setState(() => isLoading = true);

    final outputs = await classifier.classifyImage(imageFile);

    setState(() {
      dogBreed = outputs[0];
      dogProb = outputs[1];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            height: size.height * 0.4,
            width: size.width,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/th.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.35,
            height: size.height * 0.65,
            width: size.width,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36.0),
                  topRight: Radius.circular(36.0),
                ),
              ),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                children: [
                  SizedBox(height: 80),
                  Text(
                    "Prediction",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    dogBreed == "" ? "" : " $dogProb% $dogBreed ",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 90),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              if (!isClassifierInitialized) return;

                              final XFile? pickedImage = await picker.pickImage(
                                source: ImageSource.camera,
                                maxHeight: 300,
                                maxWidth: 300,
                                imageQuality: 100,
                              );

                              if (pickedImage != null) {
                                setState(() {
                                  image = File(pickedImage.path);
                                });
                                await classifySelectedImage(image);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.orange),
                              padding: EdgeInsets.all(16.0),
                              shape: CircleBorder(),
                              elevation: 10.0,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 35,
                              color: Colors.orange,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "Take photo",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 60),
                      Column(
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              if (!isClassifierInitialized) return;

                              final XFile? pickedImage = await picker.pickImage(
                                source: ImageSource.gallery,
                                maxHeight: 300,
                                maxWidth: 300,
                                imageQuality: 100,
                              );

                              if (pickedImage != null) {
                                setState(() {
                                  image = File(pickedImage.path);
                                });
                                await classifySelectedImage(image);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.blue),
                              padding: EdgeInsets.all(16.0),
                              shape: CircleBorder(),
                              elevation: 10.0,
                            ),
                            child: Icon(
                              Icons.photo,
                              size: 35,
                              color: Colors.blue[800],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "Gallery",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
