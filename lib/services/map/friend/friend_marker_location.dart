import 'dart:ui' as ui;

import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:etoet/services/map/osrm/routing.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../marker/marker.dart';

/// This class is used to create a marker for a friend
class FriendMarker {
  Routing routing = Routing.getInstance();
  late etoet.UserInfo friendInfo;
  late Future<BitmapDescriptor> friendIcon =
      GoogleMapMarker.getIconFromUrl(friendInfo.photoURL!);
  late Set<Polyline> polylines;
  late BuildContext context;
  FriendMarker({
    required this.friendInfo,
    required this.context,
    required this.polylines,
  });
  Future<Marker> createFriendMarker({
    required LatLng friendLatLng,
  }) async {
    return Marker(
      markerId: MarkerId(friendInfo.uid),
      position: friendLatLng,
      icon: await friendIcon,
      infoWindow: InfoWindow(
        title: friendInfo.displayName,
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
                      friendInfo.displayName ?? 'Etoet User',
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
                          'Show direction to ${friendInfo.displayName}',
                          style:
                              const TextStyle(fontWeight: ui.FontWeight.bold),
                        ),
                        onPressed: () async {
                          polylines.clear();
                          polylines.add(Polyline(
                              polylineId: const PolylineId('polyline'),
                              visible: true,
                              points:
                                  await routing.getPointsFromUser(friendLatLng),
                              width: 5,
                              color: Colors.blue));
                          Navigator.pop(context);
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
}
