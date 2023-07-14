import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ocr_demo/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

///Global variable to store all of the device's cameras
List<CameraDescription> cameras = [];

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    initializeDefault();
    ///Got all of the available cameras
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('CameraError: ${e.description}');
  }
  runApp(const MyApp());
}

Future<void> initializeDefault() async {
  // ignore: unused_local_variable
  FirebaseApp app = await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google OCR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}