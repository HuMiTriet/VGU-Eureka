import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/auth/user_info.dart';
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
  late GoogleMapController? _mapController;
  late StreamSubscription _locationSubscription;
  late StreamSubscription _databaseLocationSubscription;
  late final Set<Marker> _markersList = {};
  late Set<Marker> friendMarkers = {};
  final Set<Polyline> _polylinesList = {};
  Routing routing = Routing.getInstance();
  late num deviceWidth = MediaQuery.of(context).size.width *
      MediaQuery.of(context).devicePixelRatio;
  late num deviceHeight = MediaQuery.of(context).size.height *
      MediaQuery.of(context).devicePixelRatio;
  final Geocoding geocoding = Geocoding();
  late UserInfo userInfo;
  late BitmapDescriptor userIcon;
  FriendMarker friendMarkerCreator = FriendMarker();

  GoogleMapImpl({Key? key}) : super(key: key);

  @override
  String address = 'Unknown';

  @override
  late AuthUser? authUser;

  @override
  late BuildContext context;

  @override
  void updateCurrentMapAddress() async {
    address = geocoding.getGeocoding(await _mapController!.getLatLng(
        ScreenCoordinate(
            x: (deviceWidth / 2).round(), y: (deviceHeight / 2).round())));
  }

  @override
  void moveToCurrentLocation() {
    _moveMap(_location);
  }

  // update markers of all friends every one second
  void updateFriendMarker() async {
    for (var friendInfo in authUser!.friendInfoList) {
      var location = authUser!.mapFriendUidLocation[friendInfo.uid];
      location = location!;
      var latLng = LatLng(location.latitude, location.longitude);
      var friendMarker = await friendMarkerCreator.createFriendMarker(
          friendInfo: friendInfo,
          friendLatLng: latLng,
          context: context,
          polylineList: _polylinesList);
      _markersList.add(friendMarker);
      devtools.log('add friend marker displayName: ${friendInfo.displayName}',
          name: 'GoogleMap: updateFriendMarker');
    }
    devtools.log('update markers', name: 'GoogleMap: updateFriendMarker');
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
  void _updateLiveLocation(Function(Position) updateLocation) {
    // listener to update user's location and marker
    _locationSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    )).listen((position) {
      devtools.log('listener location: $position',
          name: 'GoogleMap: _updateLiveLocation');
      updateLocation(position);
    });

    // listener to update location to database
    _databaseLocationSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
    )).listen((position) {
      authUser!.location.latitude = position.latitude;
      authUser!.location.longitude = position.longitude;
      Realtime.updateUserLocation(authUser!);
      devtools.log(
          'update user location to database lat: ${position.latitude} lng: ${position.longitude}',
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
  }

  @override
  void dispose() {
    timer?.cancel();
    widget._locationSubscription.cancel();
    widget._databaseLocationSubscription.cancel();
    widget._mapController?.dispose();
    super.dispose();
  }

  void _initializeMap() async {
    devtools.log('_initializeMap', name: 'GoogleMap: _initializeMap');

    Realtime.getFriendsLocation(widget.authUser!);
    Realtime.syncFriendsLocation(widget.authUser!);
    var currentLocation = await widget._getCurrentLocation();
    Routing.location = currentLocation;
    widget.address = widget.geocoding.getGeocoding(currentLocation);
    widget.userInfo = await Firestore.getUserInfo(widget.authUser!.uid);
    widget.userIcon =
        await GoogleMapMarker.getIconFromUrl(widget.authUser!.photoURL!);
    devtools.log('userIcon: ${widget.userIcon}',
        name: 'GoogleMap: _initializeMap');
    widget._markersList.add(Marker(
        markerId: MarkerId(widget.authUser!.uid),
        position: currentLocation,
        icon: widget.userIcon));

    // listen to user's location and update location to database
    widget._updateLiveLocation((position) async {
      var location = LatLng(position.latitude, position.longitude);
      widget._location = location;
      Routing.location = widget._location;
      widget._markersList.add(
        Marker(
            markerId: MarkerId(widget.authUser!.uid),
            position: widget._location,
            icon: widget.userIcon),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.authUser = context.watch<AuthUser?>();

    var location = widget._getCurrentLocation();
    timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (mounted) {
        setState(() {
          widget.updateFriendMarker();
          widget.updateCurrentMapAddress();
        });
        timer?.cancel();
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
                  _initializeMap();
                },
                markers: widget._markersList,
                polylines: widget._polylinesList,
                myLocationEnabled: true,
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
