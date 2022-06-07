import 'dart:ui' as ui;

import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:etoet/services/map/geocoding.dart';
import 'package:etoet/services/map/osrm/routing.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../marker/marker.dart';

/// This class is used to create a marker for an emergency signal.
class EmergencyMarker {
  Routing routing = Routing.getInstance();
  late etoet.UserInfo emergencyInfo;
  late Future<BitmapDescriptor> friendIcon =
      GoogleMapMarker.getIconFromUrl(emergencyInfo.photoURL!);
  late Set<Polyline> polylines;
  late BuildContext context;
  late String uid;
  late String locationDescription;
  late String situationDetail;
  EmergencyMarker({
    required this.emergencyInfo,
    required this.context,
    required this.polylines,
    required this.uid,
    required this.locationDescription,
    required this.situationDetail,
  });
  Future<Marker> createEmergencyMarker({
    required LatLng emergencyLatLng,
  }) async {
    var location = await Geocoding.getAddress(emergencyLatLng);
    var isShowDirection = false;
    return Marker(
      markerId: MarkerId(uid),
      position: emergencyLatLng,
      icon: await friendIcon,
      infoWindow: InfoWindow(
        title: emergencyInfo.displayName,
        snippet: 'Tap to see user\'s location',
      ),
      onTap: () {
        showBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (_) {
              return Container(
                width: MediaQuery.of(context).size.width,
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
                    const Spacer(),
                    Text(
                      emergencyInfo.displayName ?? 'Etoet User',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text('Location: $location',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xfff46135),
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // fixedSize: const Size(320, 50),
                      ),
                      child: Text(
                        isShowDirection
                            ? 'Hide direction to ${emergencyInfo.displayName}'
                            : 'Show direction to ${emergencyInfo.displayName}',
                        style: const TextStyle(fontWeight: ui.FontWeight.bold),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        isShowDirection
                            ? {polylines.clear()}
                            : {
                                polylines.clear(),
                                polylines.add(Polyline(
                                    polylineId: const PolylineId('polyline'),
                                    visible: true,
                                    points: await routing
                                        .getPointsFromUser(emergencyLatLng),
                                    width: 5,
                                    color: Colors.blue))
                              };
                        isShowDirection = !isShowDirection;
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              );
            });
      },
    );
  }
}
