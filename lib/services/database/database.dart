import 'dart:developer' as devtools show log;

import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/auth/location.dart';
import 'package:firebase_database/firebase_database.dart';

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

  static void getFriendsLocation(AuthUser authUser) async {
    for (var friendInfo in authUser.friendInfoList) {
      var location = await databaseReference
          .child('users')
          .child(friendInfo.uid)
          .child('location')
          .get();
      var lat = location.child('latitude').value as double;
      var lng = location.child('longitude').value as double;
      authUser.mapFriendUidLocation[friendInfo.uid] =
          Location(latitude: lat, longitude: lng);
      devtools.log('Initial fetch friend location $lat, $lng',
          name: 'Database: fetchFriendsLocation');
    }
  }

  static void syncFriendsLocation(AuthUser authUser) {
    for (var friendInfo in authUser.friendInfoList) {
      databaseReference
          .child('users')
          .child(friendInfo.uid)
          .child('location')
          .onValue
          .listen((location) {
        var lat = location.snapshot.child('latitude').value as double;
        var lng = location.snapshot.child('longitude').value as double;
        authUser.mapFriendUidLocation[friendInfo.uid] =
            Location(latitude: lat, longitude: lng);
        devtools.log(
            'location updated from database: ID: ${friendInfo.uid} lat: $lat, lng: $lng',
            name: 'Database: syncFriendsLocation');
      });
    }
  }
}
