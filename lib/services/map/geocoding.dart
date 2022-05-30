// ignore_for_file: omit_local_variable_types

import 'dart:developer' as devtools show log;

import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// [Geocoding] can be used to convert location to placemark/address.
class Geocoding {
  Geocoding._();

  /// Get address from location
  static Future<String> getAddress(LatLng location) async {
    var placemark = await _getPlacemark(location);
    var address = _getAddressWithPriority(placemark);
    return address;
  }

  /// Is used to get the address from the [placemark] with priority from: city > administrativeArea > subAdministrativeArea > thoroughfare > subThoroughfare > subLocality > country.
  static String _getAddressWithPriority(Placemark placemark) {
    var address = 'Unknown';
    if (placemark.locality != '') {
      address = placemark.locality!;
    } else if (placemark.administrativeArea != '') {
      address = placemark.administrativeArea!;
    } else if (placemark.subAdministrativeArea != '') {
      address = placemark.subAdministrativeArea!;
    } else if (placemark.thoroughfare != '') {
      address = placemark.thoroughfare!;
    } else if (placemark.subThoroughfare != '') {
      address = placemark.subThoroughfare!;
    } else if (placemark.subLocality != '') {
      address = placemark.subLocality!;
    } else if (placemark.country != '') {
      address = placemark.country!;
    }
    return address;
  }

  /// Get placemark from location using geocoding package.
  static Future<Placemark> _getPlacemark(LatLng location) async {
    try {
      var listPlacemark =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      var placemark = listPlacemark.elementAt(0);
      var country = placemark.country;
      var city = placemark.locality;
      var street = placemark.thoroughfare;
      var subLocality = placemark.subLocality;
      var postalCode = placemark.postalCode;
      var administrativeArea = placemark.administrativeArea;
      var subAdministrativeArea = placemark.subAdministrativeArea;
      var subThoroughfare = placemark.subThoroughfare;
      devtools.log(
          'Placemark: country: $country, city: $city, administrativeArea: $administrativeArea, subAdministrativeArea: $subAdministrativeArea, street: $street, subLocality: $subLocality, subThoroughfare: $subThoroughfare, postalCode: $postalCode,',
          name: 'Geocoding: getGeocoding');
      return placemark;
    } catch (e) {
      devtools.log('get Geocoding error: $e', name: 'Geocoding: getGeocoding');
      return Placemark();
    }
  }
}
