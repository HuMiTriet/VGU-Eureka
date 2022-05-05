import 'package:etoet/services/map/google_map.dart';
import 'package:flutter/material.dart';

abstract class Map extends Widget {
  /// The address of the current map view.
  late String address;

  /// Move the camera to current location of user.
  void moveToCurrentLocation();

  /// Show the current address of the map view.
  void updateCurrentMapAddress();

  /// Update the screen size of the device.
  void updateScreenSize(num width, num height);

  /// Initialize the map.
  void initializeMap();
}

class MapDefault extends Map {
  @override
  String address = 'Address';

  @override
  Element createElement() {
    // TODO: implement createElement
    throw UnimplementedError();
  }

  @override
  void initializeMap() {
    // TODO: implement initializeMap
  }

  @override
  void moveToCurrentLocation() {
    // TODO: implement moveToCurrentLocation
  }

  @override
  void updateCurrentMapAddress() {
    // TODO: implement updateCurrentMapAddress
  }

  @override
  void updateScreenSize(num width, num height) {
    // TODO: implement updateScreenSize
  }
}

class MapFactory {
  Map getMap(String type) {
    Map map;
    switch (type) {
      case 'GoogleMap':
        {
          map = GoogleMapImpl();
          break;
        }
      default:
        {
          map = MapDefault();
          break;
        }
    }
    return map;
  }
}
