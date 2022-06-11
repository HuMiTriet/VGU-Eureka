import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:etoet/services/map/geocoding.dart';
import 'package:etoet/services/map/osrm/routing.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:etoet/services/map/marker/marker.dart';

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
    required Function helpButtonPressed,
  }) async {
    var location = await Geocoding.getAddress(emergencyLatLng);
    return Marker(
      markerId: MarkerId(uid),
      position: emergencyLatLng,
      icon: await friendIcon,
      infoWindow: InfoWindow(
        title: emergencyInfo.displayName,
        snippet: 'Tap to see user\'s location',
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('User\'s location'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(location),
                    Text('Location description: $locationDescription'),
                    Text('Situation detail: $situationDetail'),
                  ],
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Help'),
                    onPressed: () {
                      helpButtonPressed();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      },
    );
  }
}
