import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/database/firestore/firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class GeoFlutterFire {
  static CollectionReference<Map<String, dynamic>> ref =
      Firestore.firestoreReference.collection('emergencies');
  static Geoflutterfire geoflutterfire = Geoflutterfire();

  GeoFlutterFire._();

  static void updateEmergencySignalLocation(
      {required String uid, required double lat, required double lng}) async {
    var geoFirePoint = GeoFirePoint(lat, lng);
    await ref.doc(uid).update({'position': geoFirePoint.data});
  }

  static StreamSubscription querySignalInRadius(
      {required double lat, required double lng, double radius = 5.0}) {
    var center = GeoFirePoint(lat, lng);
    var field = 'position';
    var subcription = geoflutterfire
        .collection(collectionRef: ref)
        .within(center: center, radius: radius, field: field, strictMode: true)
        .listen((event) {});
    return subcription;
  }

  static String getGeohash(
      {required double latitude, required double longitude}) {
    var geoFirePoint = GeoFirePoint(latitude, longitude);
    return geoFirePoint.hash;
  }

  static Map<String, dynamic> getGeoFirePointData(
      {required double latitude, required double longitude}) {
    var geoFirePoint = GeoFirePoint(latitude, longitude);
    return geoFirePoint.data;
  }
}
