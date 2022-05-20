import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:etoet/services/map/osrm/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FriendMarker {
  static Routing routing = Routing.getInstance();
  late Polyline polyline;

  static Future<Marker> createFriendMarker(LatLng friendLatLng, String uid,
      BuildContext context, Set<Polyline> polylineList) async {
    return Marker(
      markerId: MarkerId(uid),
      position: friendLatLng,
      icon: BitmapDescriptor.fromBytes(await getBytesFromCanvas(uid)),
      infoWindow: const InfoWindow(
        title: 'Friend',
        snippet: 'Tap to see friend\'s location',
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('$uid is here'),
                  content: const Text('Need to help with something'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Icon(Icons.directions),
                      onPressed: () async {
                        polylineList.add(
                          Polyline(
                              polylineId: const PolylineId('polyline'),
                              visible: true,
                              points:
                                  await routing.getPointsFromUser(friendLatLng),
                              width: 5,
                              color: Colors.blue),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ));
      },
    );
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

  static Future<Uint8List> getBytesFromCanvas(String text) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..color = Colors.blue;
    final radius = Radius.circular(20.0);
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
