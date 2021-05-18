import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_plugin_watermark/flutter_plugin_watermark.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uint8List bytes;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              TextButton(
                onPressed: () async {
                  PickedFile file =
                      await ImagePicker().getImage(source: ImageSource.gallery);
                  if (file != null) {
                    bytes = await FlutterPluginWatermark.watermark(
                      '2021-01-01 12:12:11\n北京市朝阳区朝阳大街1号',
                      imagePath: file.path,
                      fontSize: 27,
                      bottom: 20,
                    );
                    setState(() {});
                  }
                },
                child: Text('开始'),
              ),
              bytes != null
                  ? Image.memory(
                      bytes,
                      width: 260,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
