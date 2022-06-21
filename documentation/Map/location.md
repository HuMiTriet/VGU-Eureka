# Introduction

Our application need to access the device's location system to show the user's location as well as the friends' location on the map. To do this, a plugin to connect to the device GPS is required. There are two possible plugins for this which are Location [[1]](https://pub.dev/packages/location) and Geolocator [[2]](https://pub.dev/packages/geolocator)

# Comparison

## Similarities

- Both plugins can get the device's location correctly.
- Both are well documented and simple to use.

## Differences

| Location by Bernos.dev         | Geolocator by Baseflow.com     |
| ------------------------------ | ------------------------------ |
| - Is not supported regularly.  | - Is supported more regularly. |
| - Only maintain by one person. | - Maintain by a company.       |

## Conclusion

- First our team use Location because it is the first plugin showed when searching for a plugin that can get the device's location.
- However, our team switch to the Geolocator in the final application. The reason why our team switch to another plugin is because when Flutter was updated to version 3.0.0, the Location plugin was not working as intended. The plugin was not updated to work with the new version of Flutter, so we changed to Geolocator, due to the frequent updates, and it work properly.

# How to use Geolocator

First import the plugin:

```dart
import 'package:geolocator/geolocator.dart';
```

Then to get the device location, run:

```dart
/// Get the user permission to access device's GPS
Future<bool> _hasLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return true;
  }

  /// Get the device location
Future<LatLng> getCurrentLocation() async {
  LatLng location = LatLng(0, 0);
  if (await _hasLocationPermission()) {
    var locationDataGeolocator = await Geolocator.getCurrentPosition();
    location = LatLng(
        locationDataGeolocator.latitude, locationDataGeolocator.longitude);
    return location;
  } else {
    return location;
  }
```

# References

1. Bernos.dev, Location plugin on pub.dev, from https://pub.dev/packages/location
2. Baseflow.com, Geolocator plugin on pub.dev, from https://pub.dev/packages/geolocator
