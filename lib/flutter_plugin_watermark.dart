import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FlutterPluginWatermark {
  static const MethodChannel _channel =
      const MethodChannel('flutter_plugin_watermark');

  static Future<Uint8List> watermark(String mark,
      {int fontSize = 25,
      int left = 0,
      int bottom = 0,
      String imagePath,
      String fontName = "AvenirNextCondensed-Bold",
      Uint8List imageByte}) async {
    final Uint8List version =
        await _channel.invokeMethod('watermark', <String, dynamic>{
      "imagePath": imagePath,
      "mark": mark,
      "fontSize": fontSize,
      "left": left,
      "bottom": bottom,
      "fontName": fontName,
      "imageByte": imageByte
    });
    return version;
  }
}
