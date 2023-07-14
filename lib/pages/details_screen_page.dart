import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class DetailsScreen extends StatefulWidget {
  final String? imagePath;
  const DetailsScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  late final String _imagePath;
  late final  _textDetector;
  Size? _imageSize;
  List<TextElement> _elements = [];

  List<String>? _listEmailStrings;

  @override
  void initState() {

    _imagePath = widget.imagePath!;
    ///Initializing text detector from ML Kit
    _textDetector = GoogleMlKit.vision.textRecognizer();
    ///Recognize Emails
    _recognizeEmails();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Details'),
      ),
      body: _imageSize != null ? Stack(
        children: [
          Container(
            width: double.maxFinite,
            color: Colors.black,
            child: AspectRatio(
              aspectRatio: _imageSize!.aspectRatio,
              child: Image.file(
                File(_imagePath),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Identified emails",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      child: SingleChildScrollView(
                        child: _listEmailStrings != null
                            ? ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: _listEmailStrings!.length,
                          itemBuilder: (context, index) =>
                              Text(_listEmailStrings![index]),
                        )
                            : Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ) :Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Disposing the text detector when not used anymore
    _textDetector.close();
    super.dispose();
  }

  Future<void> _getImageSize(File imageFile) async {
    // TODO: Retrieve the image size here
    final Completer<Size> completer = Completer<Size>();

    final Image _image = Image.file(imageFile);

    _image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;

    setState(() {
      _imageSize = imageSize;
    });
  }

  void _recognizeEmails() async {
    // TODO: Initialize the text recognizer here, and
    // parse the text to find email addresses in it
    _getImageSize(File(_imagePath));

    // Creating an InputImage object using the image path
    final inputImage = InputImage.fromFilePath(_imagePath);

    // Retrieving the RecognisedText from the InputImage
    final text = await _textDetector.processImage(inputImage);

    // Regular expression for verifying an email address
    String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regEx = RegExp(pattern);

    List<String> emailStrings = [];

  // Finding and storing the text String(s)
    print('Text: ${text.blocks}');
    for (TextBlock block in text.blocks) {
      for (TextLine line in block.lines) {
        if (regEx.hasMatch(line.text)) {
          emailStrings.add(line.text);
        }
      }
    }

    setState(() {
      _listEmailStrings = emailStrings;
    });

  }
}
