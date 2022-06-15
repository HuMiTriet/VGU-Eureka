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
  late Function onHelpButtonPressed;
  late Function removeMarker;
  late Function setState;
  late Function(Marker helpMarker) addHelpMarker;

  EmergencyMarker({
    required this.emergencyInfo,
    required this.context,
    required this.polylines,
    required this.uid,
    required this.locationDescription,
    required this.situationDetail,
    required this.emergencyType,
    required this.removeMarker,
    required this.setState,
    required this.addHelpMarker,
  });

  Future<Marker> createEmergencyMarker(
      {required LatLng emergencyLatLng}) async {
    var distance = await routing.getDistance(emergencyLatLng);
    var helpMarker = Marker(
      markerId: MarkerId(uid),
      position: emergencyLatLng,
      icon: await emergencyIcon,
      infoWindow: InfoWindow(
        title: emergencyInfo.displayName,
        snippet: 'Tap to see user\'s emergency details',
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
                onHelpButtonPressed: () async {},
                onAbortButtonPressed: () {
                  polylines.clear();
                  removeMarker();
                  setState();
                },
                onDoneButtonPressed: () {
                  polylines.clear();
                  removeMarker();
                  setState();
                },
                confirmedToHelp: true,
              );
            });
      },
    );
    return Marker(
      markerId: MarkerId(uid),
      position: emergencyLatLng,
      icon: await emergencyIcon,
      infoWindow: InfoWindow(
        title: emergencyInfo.displayName,
        snippet: 'Tap to see user\'s emergency details',
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
                onHelpButtonPressed: () async {
                  polylines.clear();
                  polylines.add(Polyline(
                      polylineId: PolylineId(uid),
                      visible: true,
                      points: await routing.getPointsFromUser(emergencyLatLng),
                      width: 5,
                      color: Colors.red));
                  removeMarker();
                  addHelpMarker(helpMarker);
                  setState();
                },
                onAbortButtonPressed: () {
                  polylines.clear();
                  removeMarker();
                  setState();
                },
                onDoneButtonPressed: () {
                  polylines.clear();
                  removeMarker();
                  setState();
                },
              );
            });
      },
    );
  }
}
