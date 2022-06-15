import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:etoet/services/auth/auth_user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Realtime {
  /// Points to the remote database
  static final databaseReference = FirebaseDatabase.instance.ref();

  /// Private constructor
  Realtime._() {
    devtools.log('NEW REALTIME DATABASE REFERENCE INSTANCE');
  }

  static void updateUserLocation(AuthUser authUser) {
    var location =
        databaseReference.child('users').child(authUser.uid).child('location');

    location.set(authUser.location.toJson()).then((value) => devtools.log(
        'location updated to database: $databaseReference'
        '\n'
        'userId: ${authUser.uid}'
        '\n'
        'lat: ${authUser.location.latitude} lng: ${authUser.location.longitude}',
        name: 'Database: updateUserLocation'));
  }

  static Set<StreamSubscription> syncFriendsLocation(AuthUser authUser) {
    var streamSubscriptionSet = <StreamSubscription>{};
    for (var friendInfo in authUser.friendInfoList) {
      var subscription = databaseReference
          .child('users')
          .child(friendInfo.uid)
          .onValue
          .listen((location) {
        var lat = location.snapshot.child('location').child('latitude').value
            as double;
        var lng = location.snapshot.child('location').child('longitude').value
            as double;
        devtools.log(
            'location updated from database: ID: ${friendInfo.uid} lat: $lat, lng: $lng',
            name: 'Database: syncFriendsLocation');
      });
      streamSubscriptionSet.add(subscription);
    }
    return streamSubscriptionSet;
  }

  static Future<LatLng> getUserLocation(String uid) async {
    var location = await databaseReference
        .child('users')
        .child(uid)
        .child('location')
        .get();

    return LatLng(
      location.child('latitude').value as double,
      location.child('longitude').value as double,
    );
  }
}
