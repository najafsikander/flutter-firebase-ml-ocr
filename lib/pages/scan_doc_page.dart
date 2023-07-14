import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ocr_demo/main.dart';
import 'package:flutter_ocr_demo/pages/details_screen_page.dart';

class ScanDocPage extends StatefulWidget {
  final String title;
  const ScanDocPage ({Key? key, required this.title}) : super(key: key);
  @override
  _ScanDocPageState createState() => _ScanDocPageState();
}

class _ScanDocPageState extends State<ScanDocPage> {
  double _width = 0;
  double _height = 0;
  late final CameraController _controller;

  ///init lifecycle method
  @override
  void initState() {

    _initializeCameraController();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // ignore: sized_box_for_whitespace
      body: _controller.value.isInitialized?Container(
        width: _width,
        height: _height,
        child: Stack(
          children: [
            SizedBox(
              height: _height,
              child: CameraPreview(_controller),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: _width,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.camera),
                    label: const Text('Take Picture'),
                    onPressed: () async {
                      final String? _imagePath = await _takePicture();
                      print('Image taken: $_imagePath');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(imagePath: _imagePath)));
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      )
          : Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  ///dispose lifecycle method
  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  ///initialize camera controller
  void _initializeCameraController() {

    ///Initializing local camera controller
    final CameraController cameraController = CameraController(
      cameras.first, /// passing camera which we fetched in main class
      ResolutionPreset.ultraHigh /// passing resolution preset/quality of camera
    );

    _controller = cameraController;

    ///initializing controller
    _controller.initialize().then((_state)  {
      if(!mounted) return;

      setState(() {

      });
    } );
  }

  ///take picture from camera
  Future<String?> _takePicture() async {

    ///Checking if camera is initialized
    if(!_controller.value.isInitialized) {
      print('Camera is not initialized');
      return null;
    }

    ///Checking if camera is busy taking picture
    if(_controller.value.isTakingPicture) {
      print('Camera is busy taking picture');
      return null;
    }

    String? _imagePath;
    try {
      ///Turning off flash
      _controller.setFlashMode(FlashMode.off);

      ///Taking picture and storing it in file
      final XFile _file =await _controller.takePicture();

      _imagePath = _file.path;
    } on CameraException catch (e){
      print('Error caught while taking picture: ${e.description}');
      return null;
    }

    return _imagePath;
  }
}
