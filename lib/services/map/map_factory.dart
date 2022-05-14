import 'package:etoet/services/map/google_map.dart';
import 'package:flutter/material.dart';

abstract class Map extends Widget {
  factory Map(String type) {
    if (type == 'GoogleMap') {
      return GoogleMapImpl();
    }
    throw 'Can\'t create $type.';
  }

  /// The address of the current map view.
  late String address;

  void setContext(BuildContext context);

  /// Move the camera to current location of user.
  void moveToCurrentLocation();

  /// Show the current address of the map view.
  void updateCurrentMapAddress();

  /// Update the screen size of the device.
  void updateScreenSize(num width, num height);

  /// Initialize the map.
  void initializeMap();
}
