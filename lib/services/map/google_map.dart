import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/database/database.dart';
import 'package:etoet/services/database/firestore.dart';
import 'package:etoet/services/map/friend/friend_marker_location.dart';
import 'package:etoet/services/map/map_factory.dart';
import 'package:etoet/services/map/marker/marker.dart';
import 'package:etoet/services/map/osrm/routing.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'geocoding.dart';

/// This is the implementation of the [Map] interface using [GoogleMap].
///
/// # Functions:
/// - moveToCurrentLocation() - moves the map to the current location
/// - updateCurrentMapAddress() - update the current addressList that the map shows
/// - initializeMap() - initializes the map(move the map to current location, update addressList)
class GoogleMapImpl extends StatefulWidget implements Map {
  late LatLng _location = const LatLng(0, 0);
  late GoogleMapController _mapController;
  late StreamSubscription _locationSubscription;
  late StreamSubscription _databaseLocationSubscription;
  late Set<StreamSubscription> _friendsLocationSubscriptions;
  final List<Marker> _markers = [];
  final Set<Polyline> _polylines = {};
  Routing routing = Routing.getInstance();
  late num deviceWidth = MediaQuery.of(context).size.width *
      MediaQuery.of(context).devicePixelRatio;
  late num deviceHeight = MediaQuery.of(context).size.height *
      MediaQuery.of(context).devicePixelRatio;

  GoogleMapImpl({Key? key}) : super(key: key);

  @override
  String address = 'Unknown';

  @override
  late BuildContext context;

  @override
  late AuthUser? authUser;

  @override
  void moveToCurrentLocation() {
    _moveMap(_location);
  }

  /// Update the current address that the map shows
  void updateCurrentMapAddress() async {
    address = await Geocoding.getGeocoding(await _mapController.getLatLng(
        ScreenCoordinate(
            x: (deviceWidth / 2).round(), y: (deviceHeight / 2).round())));
  }

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

  Future<LatLng> _getCurrentLocation() async {
    if (await _hasLocationPermission()) {
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
  /// The user's location is updated to the database
  StreamSubscription _getLocationStream(
      Function(Position) updateLocation, int range) {
    // listener to update user's location and marker
    return Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: range,
    )).listen((position) {
      updateLocation(position);
    });
  }

  void _moveMap(LatLng location) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
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
  late Future<LatLng> location = widget._getCurrentLocation();
  late BitmapDescriptor userIcon;

  void _initializeMap() async {
    devtools.log('_initializeMap', name: 'GoogleMap: _initializeMap');

    widget._friendsLocationSubscriptions =
        Realtime.syncFriendsLocation(widget.authUser!);

    // get location, update geocoding
    var currentLocation = await widget._getCurrentLocation();
    Routing.location = currentLocation;
    widget.address = await Geocoding.getGeocoding(currentLocation);

    // get user icon, draw marker
    var icon = await GoogleMapMarker.getIconFromUrl(widget.authUser!.photoURL!);
    userIcon = icon;
    widget._locationSubscription = widget._getLocationStream((position) {
      var location = LatLng(position.latitude, position.longitude);
      widget._location = location;
      Routing.location = location;
      widget._markers.add(Marker(
          markerId: MarkerId(widget.authUser!.uid),
          position: location,
          icon: icon));
      devtools.log('location: $location, user marker: ${widget._markers.first}',
          name: 'GoogleMap: _getLocationStream');
    }, 5);

    // listen to user's location and update location to database
    widget._databaseLocationSubscription =
        widget._getLocationStream((position) {
      widget.authUser?.location.latitude = position.latitude;
      widget.authUser?.location.longitude = position.longitude;
      Realtime.updateUserLocation(widget.authUser!);
      devtools.log(
          'update user location to database lat: ${position.latitude} lng: ${position.longitude}',
          name: 'GoogleMap: _getLocationStream');
    }, 10);

    devtools.log('Finish _initializeMap', name: 'GoogleMap: _initializeMap');
  }

  /// Update markers of all friends
  void updateFriendMarker() async {
    var friendInfoList = widget.authUser?.friendInfoList ?? {};
    for (var friendInfo in friendInfoList) {
      var friendMarkerCreator = FriendMarker(
          context: context,
          friendInfo: friendInfo,
          polylines: widget._polylines);
      var location = widget.authUser?.mapFriendUidLocation[friendInfo.uid];
      var latLng = LatLng(location!.latitude, location.longitude);
      var friendMarker =
          await friendMarkerCreator.createFriendMarker(friendLatLng: latLng);
      widget._markers
          .removeWhere((marker) => marker.markerId == MarkerId(friendInfo.uid));
      widget._markers.add(friendMarker);
      devtools.log('marker list: ${widget._markers.length}',
          name: 'GoogleMap: updateFriendMarker');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    widget._mapController.dispose();
    widget._locationSubscription.cancel();
    widget._databaseLocationSubscription.cancel();
    for (var subscription in widget._friendsLocationSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.authUser = context.watch<AuthUser?>();
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (mounted) {
        updateFriendMarker();
        widget.updateCurrentMapAddress();
        setState(() {});
      }
    });
    return FutureBuilder(
      future: location,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var location = snapshot.data;
          return Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: location as LatLng,
                  zoom: 15,
                ),
                onMapCreated: (controler) {
                  widget._mapController = controler;
                  devtools.log(
                      'Google map state build _mapController: ${widget._mapController}',
                      name: 'GoogleMapImplState');
                },
                markers: widget._markers.toSet(),
                polylines: widget._polylines,
                // myLocationEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
              ),
              Positioned(
                top: 40,
                left: 10,
                child: Text(
                  widget.address,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Color.fromARGB(104, 220, 155, 69),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
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
