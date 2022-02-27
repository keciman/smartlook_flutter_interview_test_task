import 'dart:async';
import 'dart:ui' as ui;

import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

class Functions {
  /// these functions could be parallelized together for bigger app
  static Future<Color> getAverageColorFromImage(ImageProvider provider) async {
    final stream = provider.resolve(ImageConfiguration.empty);
    final Completer completer = Completer<ui.Image>();
    final ImageStreamListener listener = ImageStreamListener((frame, sync) {
      final ui.Image image = frame.image;
      completer.complete(image);
    });
    stream.addListener(listener);
    final ui.Image image = await completer.future;
    stream.removeListener(listener);

    final byteData = await image.toByteData();
    final byteList = byteData.buffer;
    final img.Image pixelImage =
        img.Image.fromBytes(image.width, image.height, byteList.asUint8List());

    ///the average is summed by horizontal and vertical cross
    ///this is just my idea of effective solution
    ///but for sure there are much more effective and more accurate
    ///solutions out there
    ///PARTIALLY INSPIRED FROM STACK OVERFLOW - hope it is not a problem:)
    int redBucket = 0;
    int greenBucket = 0;
    int blueBucket = 0;
    int pixelCount = 0;

    final halfWidth = pixelImage.width ~/ 2;
    for (int i = 0; i < pixelImage.height; i += pixelImage.height ~/ 10) {
      final val = pixelImage.getPixel(halfWidth, i);
      pixelCount++;
      redBucket += img.getRed(val);
      greenBucket += img.getGreen(val);
      blueBucket += img.getBlue(val);
    }
    final halfHeight = pixelImage.height ~/ 2;
    for (int i = 0; i < pixelImage.width; i += pixelImage.width ~/ 10) {
      final val = pixelImage.getPixel(halfHeight, i);
      pixelCount++;
      redBucket += img.getRed(val);
      greenBucket += img.getGreen(val);
      blueBucket += img.getBlue(val);
    }
    return Color.fromRGBO(redBucket ~/ pixelCount, greenBucket ~/ pixelCount,
        blueBucket ~/ pixelCount, 1);
  }
}
