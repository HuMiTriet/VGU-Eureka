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
        showModalBottomSheet(
            isDismissible: true,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (_) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: const BoxDecoration(
                  color: Color(0xFFffa858),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      uid,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                        'Location: ${friendLatLng.latitude}, ${friendLatLng.longitude}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xfff46135),
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize: const Size(320, 50),
                        ),
                        child: Text(
                          'Show direction to $uid',
                          style:
                              const TextStyle(fontWeight: ui.FontWeight.bold),
                        ),
                        onPressed: () async {
                          polylineList.add(
                            Polyline(
                                polylineId: const PolylineId('polyline'),
                                visible: true,
                                points: await routing
                                    .getPointsFromUser(friendLatLng),
                                width: 5,
                                color: Colors.blue),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            });
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
