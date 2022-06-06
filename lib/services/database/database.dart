import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/map/geoflutterfire/geoflutterfire.dart';
import 'package:firebase_database/firebase_database.dart';

class Realtime {
  /// Points to the remote database
  static final databaseReference = FirebaseDatabase.instance.ref();

  /// Private constructor
  Realtime._() {
    devtools.log('NEW REALTIME DATABASE REFERENCE INSTANCE');
  }

  static void updateUserLocation(AuthUser authUser) {
    var userReference = databaseReference.child('users').child(authUser.uid);

    var geohash = GeoFlutterFire.getGeohash(
        latitude: authUser.location.latitude,
        longitude: authUser.location.longitude);

    userReference.set({
      'location': authUser.location.toJson(),
      'geohash': geohash
    }).then((value) => devtools.log(
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
}
