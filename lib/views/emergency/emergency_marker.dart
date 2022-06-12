import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:etoet/services/map/marker/marker.dart';
import 'package:etoet/services/map/osrm/routing.dart';
import 'package:etoet/views/modal_bottom_sheet/confirm_box.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// This class is used to create a marker for an emergency signal.
class EmergencyMarker {
  Routing routing = Routing.getInstance();
  late etoet.UserInfo emergencyInfo;
  late Future<BitmapDescriptor> emergencyIcon =
      GoogleMapMarker.getIconFromUrl(emergencyInfo.photoURL!);
  late Set<Polyline> polylines;
  late BuildContext context;
  late String uid;
  late String locationDescription;
  late String situationDetail;
  late String emergencyType;
  EmergencyMarker({
    required this.emergencyInfo,
    required this.context,
    required this.polylines,
    required this.uid,
    required this.locationDescription,
    required this.situationDetail,
    required this.emergencyType,
  });
  Future<Marker> createEmergencyMarker({
    required LatLng emergencyLatLng,
    required Function helpButtonPressed,
  }) async {
    var distance = await routing.getDistance(emergencyLatLng);
    return Marker(
      markerId: MarkerId(uid),
      position: emergencyLatLng,
      icon: await emergencyIcon,
      infoWindow: InfoWindow(
        title: emergencyInfo.displayName,
        snippet: 'Tap to see user\'s location',
      ),
      onTap: () {
        showModalBottomSheet(
            barrierColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Confirmbox(
                locationDescription: locationDescription,
                situationDetail: situationDetail,
                distance: distance,
                needHelpUser: emergencyInfo,
                emergencyType: emergencyType,
              );
            });
      },
    );
  }
}
