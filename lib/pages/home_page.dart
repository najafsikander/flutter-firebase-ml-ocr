import 'package:flutter/material.dart';
import 'package:flutter_ocr_demo/pages/scan_doc_page.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final String title;

  HomePage({Key? key, required this.title}) : super(key: key);

  double _width = 0;
  double _height = 0;

  @override
  Widget build(BuildContext context) {

    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      // ignore: sized_box_for_whitespace
      body: Container(
        width: _width,
        height: _height,
        child: Center(
          child: ElevatedButton(
            child: const Text('Scan Document',
              style: TextStyle(
                  fontSize: (20)
              ),),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ScanDocPage(title: 'Scan Document')));
            },
          ),
        ),
      ),
    );
  }
}


