import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:etoet/services/map/marker/marker.dart';
import 'package:etoet/services/map/osrm/routing.dart';
import 'package:etoet/views/popup_sos_message/sos_received_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// This class is used to create a marker for an emergency signal.
class HelperMarker {
  Routing routing = Routing.getInstance();
  late etoet.UserInfo helperInfo;
  late Future<BitmapDescriptor> emergencyIcon =
      GoogleMapMarker.getIconFromUrl(helperInfo.photoURL!);
  late Set<Polyline> polylines;
  late BuildContext context;

  HelperMarker({
    required this.helperInfo,
    required this.context,
    required this.polylines,
  });

  Future<Marker> createEmergencyMarker({required LatLng helperLatLng}) async {
    num distance = await routing.getDistance(helperLatLng);
    distance = num.parse(distance.toStringAsFixed(2));
    polylines.add(Polyline(
      polylineId: PolylineId(helperInfo.uid),
      visible: true,
      points: await routing.getPointsFromUser(helperLatLng),
      color: Colors.red,
      width: 5,
    ));
    return Marker(
      markerId: MarkerId(helperInfo.uid),
      position: helperLatLng,
      icon: await emergencyIcon,
      infoWindow: InfoWindow(
        title: helperInfo.displayName,
        snippet: 'Tap to see helper details',
      ),
      onTap: () {
        showModalBottomSheet(
            barrierColor: Colors.transparent,
            context: context,
            builder: (context) {
              return SoSReceivedBottomSheet(
                helperInfo: helperInfo,
                distance: distance as double,
              );
            });
      },
    );
  }
}
