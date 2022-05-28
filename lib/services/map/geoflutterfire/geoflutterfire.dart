import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/database/firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class GeoFlutterFire {
  static CollectionReference<Map<String, dynamic>> ref =
      Firestore.firestoreReference.collection('emergencies');
  static Geoflutterfire geo = Geoflutterfire();
  GeoFlutterFire._();

  static GeoFirePoint getGeoFirePoint(double lat, double lng) {
    return GeoFirePoint(lat, lng);
  }

  static void updateEmergencySignalLocation(
      {required String uid, required double lat, required double lng}) async {
    var geoFirePoint = GeoFirePoint(lat, lng);
    await ref.doc(uid).update({
      'postion': {
        'hash': geoFirePoint.hash,
        'geopoint': geoFirePoint.geoPoint,
      }
    });
  }

  static StreamSubscription querySignalInRadius(
      GeoFirePoint center, double radius) {
    var field = 'position';
    var subcription = geo
        .collection(collectionRef: ref)
        .within(center: center, radius: radius, field: field)
        .listen((event) {
      for (var doc in event) {
        var data = doc.data();
        log(data.toString());
      }
    });
    return subcription;
  }
}
