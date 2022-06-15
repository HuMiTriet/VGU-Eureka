import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:etoet/services/map/google_map.dart';
import 'package:flutter/material.dart';

/// The factory class for the map.
abstract class Map extends Widget {
  factory Map(String type) {
    if (type == 'GoogleMap') {
      return GoogleMapImpl();
    }
    throw 'Can\'t create $type.';
  }

  /// The address of the current map view.
  late String address;

  late AuthUser? authUser;

  late BuildContext context;

  /// Move the camera to current location of user.
  void moveToCurrentLocation();

  void addHelperMarker({required etoet.UserInfo helperInfo});
}
