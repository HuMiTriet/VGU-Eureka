import 'dart:developer' as devtools show log;

import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/auth/location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tuple/tuple.dart';

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

  static void getUserLocation(AuthUser authUser) async {
    for (var friendUID in authUser.friendUIDs) {
      var location = await databaseReference
          .child('users')
          .child(friendUID)
          .child('location')
          .get();
      var lat = location.child('latitude').value as double;
      var lng = location.child('longitude').value as double;
      authUser.setFriendUIDLocation
          .add(Tuple2(friendUID, Location(latitude: lat, longitude: lng)));
      devtools.log('Initial fetch friend location $lat, $lng',
          name: 'Database: fetchUserLocation');
    }
  }

  static void syncUserLocation(AuthUser authUser) {
    for (var friendUID in authUser.friendUIDs) {
      databaseReference
          .child('users')
          .child(friendUID)
          .child('location')
          .onValue
          .listen((location) {
        var lat = location.snapshot.child('latitude').value as double;
        var lng = location.snapshot.child('longitude').value as double;
        authUser.setFriendUIDLocation
            .add(Tuple2(friendUID, Location(latitude: lat, longitude: lng)));
        devtools.log(
            'location updated from database: ID: $friendUID lat: $lat, lng: $lng',
            name: 'Database: syncUserLocation');
      });
    }
  }
}
