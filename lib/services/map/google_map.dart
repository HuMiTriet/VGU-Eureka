import 'dart:async';
import 'dart:developer' as devtools show log;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/database/database.dart';
import 'package:etoet/services/map/friend/friend_marker_location.dart';
import 'package:etoet/services/map/map_factory.dart';
import 'package:etoet/services/map/osrm/routing.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// This is the implementation of the [Map] interface using [GoogleMap].
///
/// # Functions:
/// - moveToCurrentLocation() - moves the map to the current location
/// - updateCurrentMapAddress() - update the current addressList that the map shows
/// - initializeMap() - initializes the map(move the map to current location, update addressList)
class GoogleMapImpl extends StatefulWidget implements Map {
  late BuildContext context;
  late LatLng _location = const LatLng(11.0551, 106.6657);
  late GoogleMapController? _mapController;
  late StreamSubscription _locationSubscription;
  late final Set<Marker> _markersList = {userMarker};
  late Marker userMarker = Marker(
    markerId: const MarkerId('user'),
    position: _location,
  );
  late Set<Marker> friendMarkers = {};
  Set<Polyline> _polylinesList = {};
  Routing routing = Routing.getInstance();
  late num deviceWidth = MediaQuery.of(context).size.width *
      MediaQuery.of(context).devicePixelRatio;
  late num deviceHeight = MediaQuery.of(context).size.height *
      MediaQuery.of(context).devicePixelRatio;
  List<String> addressList = ['', '', '', '', '', '', '', ''];

  GoogleMapImpl({Key? key, required this.authUser}) : super(key: key);

  @override
  AuthUser authUser;

  @override
  void setContext(BuildContext context) {
    this.context = context;
  }

  @override
  String address = 'Unknown';

  @override
  void initializeMap() async {
    devtools.log('initialize map', name: 'GoogleMap: initializeMap');

    devtools.log('friend: ${authUser.friendUIDs}',
        name: 'GoogleMap: initializeMap');
    var currentLocation = await _getCurrentLocation();
    authUser.location.latitude = currentLocation.latitude;
    authUser.location.longitude = currentLocation.longitude;
    Database.updateUserLocation(authUser);
    _moveMap(currentLocation);
    _updateCurrentAddress(currentLocation);
    updateCurrentMapAddress();
    devtools.log('finish initialize map', name: 'GoogleMap: initializeMap');
  }

  @override
  void updateCurrentMapAddress() async {
    _updateCurrentAddress(await _mapController!.getLatLng(ScreenCoordinate(
        x: (deviceWidth / 2).round(), y: (deviceHeight / 2).round())));
  }

  @override
  void moveToCurrentLocation() {
    _moveMap(_location);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Uint8List> getBytesFromCanvas(String text) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    final Radius radius = Radius.circular(20.0);
    final int width = 100;
    final int height = 100;
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);
    var painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: const TextStyle(fontSize: 25.0, color: Colors.white),
    );
    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * 0.5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  void updateMarkers() async {
    // final markerIcon = await getBytesFromCanvas('FRIEND');
    // final anyaBytes = await getBytesFromAsset('assets/images/Anya.png', 100);
    // var anyaLocation = const LatLng(11.0551, 106.6657);
    // final loidBytes = await getBytesFromAsset('assets/images/Loid.png', 100);
    // var loidLocation = const LatLng(10.7827, 106.71);
    // final yorBytes = await getBytesFromAsset('assets/images/Yor.png', 100);
    // var yorLocation = const LatLng(10.7288, 106.7188);

    // update markers of all friends every one second
    for (var friendUID in authUser.friendUIDs) {
      var friendData = await Database.databaseReference
          .child('users')
          .child(friendUID)
          .child('location')
          .get();
      var lat = friendData.child('latitude').value as double;
      var lng = friendData.child('longitude').value as double;

      var latLng = LatLng(lat, lng);
      devtools.log('friendData: ${friendData.value}',
          name: 'GoogleMap: updateMarkers');
      var friendMarker = await FriendMarker.createFriendMarker(
          latLng, friendUID, context, _polylinesList);
      _markersList.add(friendMarker);
    }
    devtools.log('update markers of friends', name: 'updateMarkers');
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
            name: 'GoogleMap: _updateCurrentAddress');
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
        name: 'GoogleMap: _updateGeocoding');
  }

  Future<bool> hasLocationPermission() async {
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

  Future<LatLng> _getCurrentLocation() async {
    if (await hasLocationPermission()) {
      var locationDataGeolocator = await Geolocator.getCurrentPosition();
      _location = LatLng(
          locationDataGeolocator.latitude, locationDataGeolocator.longitude);
      devtools.log('locationData: $locationDataGeolocator',
          name: 'GoogleMap: _getCurrentLocation');
      return _location;
    }
    return _location;
  }

  /// Listener to user location
  ///
  /// When the user's location changes, the marker for user is moved to the new location.
  /// The user's location is also update to the database
  void _updateLiveLocation() {
    // listener to update user's location and marker
    _locationSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
    )).listen((position) {
      _location = LatLng(position.latitude, position.longitude);
      _markersList.add(Marker(
        markerId: const MarkerId('user'),
        position: _location,
      ));
      devtools.log('locationData: $position',
          name: 'GoogleMap: _updateLiveLocation');
    });

    // listener to update location to database
    Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
    )).listen((position) async {
      authUser.location.latitude = position.latitude;
      authUser.location.longitude = position.longitude;
      Database.updateUserLocation(authUser);
      devtools.log('update user location to database',
          name: 'GoogleMap: _updateLiveLocation');
    });
  }

  void _moveMap(LatLng location) {
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: location,
        zoom: 15.0,
      ),
    ));
    devtools.log('_moveMap to $location', name: 'GoogleMap: _moveMap');
  }

  @override
  State<StatefulWidget> createState() => _GoogleMapImplState();
}

class _GoogleMapImplState extends State<GoogleMapImpl> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    widget._updateLiveLocation();
    Routing.location = widget._location;

    // mock friend data(can retrieve this info from the database at start up)
    widget.authUser.friendUIDs.add('DGQqAvqtwyg45GRzGVQSdqGsGhq1');
    widget.authUser.friendUIDs.add('T4AMYi2auOOl3b0jNfGwKOiwEmx1');
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _updateMap() async {
    var currentLocation = await widget._getCurrentLocation();
    widget._moveMap(currentLocation);
    widget._updateCurrentAddress(currentLocation);
    widget._updateLiveLocation();
    devtools.log('_updateMap', name: 'GoogleMap: _updateMap');
  }

  @override
  Widget build(BuildContext context) {
    widget._updateLiveLocation();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          widget.updateMarkers();
        });
      }
      timer?.cancel();
    });
    return FutureBuilder(
      future: widget._getCurrentLocation(),
      builder: (context, AsyncSnapshot<LatLng> snapshot) {
        if (snapshot.hasData) {
          var location = snapshot.data;
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: location!,
              zoom: 15,
            ),
            onMapCreated: (controler) {
              widget._mapController = controler;
              devtools.log(
                  'Google map state build _map: ${widget._mapController}',
                  name: 'GoogleMapImplState');
              _updateMap();
            },
            markers: widget._markersList,
            polylines: widget._polylinesList,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
