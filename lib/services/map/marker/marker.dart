import 'dart:developer' as devtools show log;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Convert to google map marker icon from different image source.
class GoogleMapMarker {
  /// Get marker icon from URL
  static Future<BitmapDescriptor> getIconFromUrl(String url) async {
    return BitmapDescriptor.fromBytes(await getBytesFromUrlResize(url, 100));
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    var data = await rootBundle.load(path);
    var codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    var fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static Future<Uint8List> getBytesFromUrlResize(String url, int width) async {
    var originalByteData = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();
    var codec = await ui.instantiateImageCodec(originalByteData,
        targetHeight: width, targetWidth: width);
    var frameInfo = await codec.getNextFrame();
    var targetUiImage = frameInfo.image;

    var targetByteData =
        await targetUiImage.toByteData(format: ui.ImageByteFormat.png);
    devtools.log(
        'target image ByteData size is ${targetByteData?.lengthInBytes}',
        name: 'GoogleMapMarker: getBytesFromUrlResize');
    var targetlUinit8List = targetByteData?.buffer.asUint8List();
    return targetlUinit8List!;
  }

  static Future<Uint8List> getBytesFromCanvas(String text) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..color = Colors.blue;
    const radius = Radius.circular(20.0);
    const width = 100;
    const height = 100;
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);
    var painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: const TextStyle(fontSize: 25.0, color: Colors.white),
    );
    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * 0.5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }
}
