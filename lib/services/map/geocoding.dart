import 'dart:developer' as devtools show log;

import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// [Geocoding] can be used to convert location to placemark/address.
class Geocoding {
  List<String> addressList = <String>['', '', '', '', '', '', '', ''];
  String getGeocoding(LatLng location) {
    try {
      placemarkFromCoordinates(location.latitude, location.longitude)
          .then((listPlacemark) {
        var placemarkAddress = listPlacemark.elementAt(0);
        var country = placemarkAddress.country;
        var city = placemarkAddress.locality;
        var street = placemarkAddress.thoroughfare;
        var subLocality = placemarkAddress.subLocality;
        var postalCode = placemarkAddress.postalCode;
        var administrativeArea = placemarkAddress.administrativeArea;
        var subAdministrativeArea = placemarkAddress.subAdministrativeArea;
        var subThoroughfare = placemarkAddress.subThoroughfare;
        addressList[0] = '$country';
        addressList[1] = '$city';
        addressList[2] = '$street';
        addressList[3] = '$subLocality';
        addressList[4] = '$postalCode';
        addressList[5] = '$administrativeArea';
        addressList[6] = '$subAdministrativeArea';
        addressList[7] = '$subThoroughfare';
        devtools.log('geocoding of location: $addressList',
            name: 'Geocoding: getGeocoding');
        return _getAddress();
      });
    } catch (e) {
      devtools.log('get Geocoding error: $e', name: 'Geocoding: getGeocoding');
    }
    return _getAddress();
  }

  /// [_getAddress] is used to get the address from the addressList with priority from: city > administrativeArea > subAdministrativeArea > subThoroughfare > country.
  String _getAddress() {
    var address = 'Unknown';
    // city
    if (addressList[1] != '') {
      address = addressList[1];

      // administrativeArea
    } else if (addressList[5] != '') {
      address = addressList[5];

      // subAdministrativeArea
    } else if (addressList[6] != '') {
      address = addressList[6];

      // subThoroughfare
    } else if (addressList[7] != '') {
      address = addressList[7];

      // country
    } else if (addressList[0] != '') {
      address = addressList[0];
    }
    devtools.log('get address: $address', name: 'Geocoding: _getAddress');
    return address;
  }
}
