import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:etoet/services/map/map_factory.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

/// This is the implementation of the [Map] interface using [GoogleMap].
///
/// It is used by the [MainView] widget.
/// ## Functions:
/// - moveToCurrentLocation() - moves the map to the current location
/// - updateCurrentMapAddress() - shows the current addressList that the map shows
/// - updateScreenSize() - updates the screen size of the device
/// - initializeMap() - initializes the map(move the map to current location, update addressList)
class GoogleMapImpl extends StatefulWidget implements Map {
  late LatLng initialLocation = const LatLng(11.0551, 106.6657);

  late GoogleMapController? _mapController;

  late StreamSubscription _locationSubscription;
  final loc.Location _locationTracker = loc.Location();
  Set<Marker> _markersList = {};
  Set<Polyline> _polylinesList = {};
  late num deviceWidth;
  late num deviceHeight;

  set markersList(Set<Marker> markersList) {
    _markersList = markersList;
  }

  set polylinesList(Set<Polyline> polylinesList) {
    _polylinesList = polylinesList;
  }

  Set<Marker> get markersList => _markersList;
  Set<Polyline> get polylinesList => _polylinesList;
  late List<String> addressList = ['', '', '', '', '', '', '', ''];

  GoogleMapImpl({Key? key}) : super(key: key);

  @override
  String address = 'Unknown';

  @override
  void initializeMap() async {
    devtools.log('initialize map', name: 'initializeMap');
    _moveMap(await _getCurrentLocation());
    _updateCurrentAddress(await _getCurrentLocation());
    _updateLiveLocation();
  }

  @override
  void updateScreenSize(num width, num height) {
    deviceWidth = width;
    deviceHeight = height;
  }

  @override
  void updateCurrentMapAddress() async {
    _updateCurrentAddress(await _mapController!.getLatLng(ScreenCoordinate(
        x: (deviceWidth / 2).round(), y: (deviceHeight / 2).round())));
  }

  @override
  void moveToCurrentLocation() async {
    _updateCurrentLocation();
    _moveMap(await _getCurrentLocation());
  }

  void _updateCurrentAddress(LatLng location) {
    try {
      placemarkFromCoordinates(location.latitude, location.longitude)
          .then((listPlacemark) {
        Placemark placemarkAddress;
        placemarkAddress = listPlacemark.elementAt(0);
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
        devtools.log('update map current addressList: $addressList',
            name: '_updateCurrentAddress');
        _updateGeocoding();
      });
    } on Exception catch (e) {
      e.toString();
    }
  }

  void _updateGeocoding() {
    address = 'Unknown';
    if (addressList[1] != '') {
      address = addressList[1];
    } else if (addressList[5] != '') {
      address = addressList[5];
    } else if (addressList[6] != '') {
      address = addressList[6];
    } else if (addressList[7] != '') {
      address = addressList[7];
    } else if (addressList[0] != '') {
      address = addressList[0];
    }
    devtools.log('update map Geocoding, set addressList: $address',
        name: '_updateGeocoding');
  }

  Future<LatLng> _getCurrentLocation() async {
    var locationData = await loc.Location().getLocation();
    devtools.log('locationData: $locationData', name: '_getCurrentLocation');
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  void _updateCurrentLocation() async {
    initialLocation = await _getCurrentLocation();
    devtools.log('_initialLocation');
  }

  void _updateLiveLocation() {
    _locationSubscription =
        _locationTracker.onLocationChanged.listen((locationData) {
      initialLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  void _moveMap(LatLng location) {
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: location,
        zoom: 15.0,
      ),
    ));
    devtools.log('_moveMap to $location', name: '_moveMap');
  }

  @override
  State<StatefulWidget> createState() => _GoogleMapImplState();
}

class _GoogleMapImplState extends State<GoogleMapImpl> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateMap() async {
    widget._moveMap(await widget._getCurrentLocation());
    widget._updateCurrentAddress(await widget._getCurrentLocation());
    widget._updateLiveLocation();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.initialLocation,
        zoom: 15,
      ),
      onMapCreated: (controler) {
        widget._mapController = controler;
        devtools.log('Google map state build _map: ${widget._mapController}',
            name: 'GoogleMapImplState');
        _updateMap();
      },
      markers: widget.markersList,
      polylines: widget.polylinesList,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      // onCameraMove: (value) {
      //   widget._updateCurrentAddress(value.target);
      // },
    );
  }
}
