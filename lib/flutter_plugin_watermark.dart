import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FlutterPluginWatermark {
  static const MethodChannel _channel =
      const MethodChannel('flutter_plugin_watermark');

  static Future<Uint8List> watermark(String imagePath, String mark,
      {int fontSize = 25,
      int left = 70,
      int bottom = 140,
      int height = 160,
      String fontName = "AvenirNextCondensed-Bold"}) async {
    final Uint8List version =
        await _channel.invokeMethod('watermark', <String, dynamic>{
      "imagePath": imagePath,
      "mark": mark,
      "fontSize": fontSize,
      "left": left,
      "bottom": bottom,
      "fontName": fontName,
    });
    return version;
  }
}
