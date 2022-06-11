import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/auth/location.dart';
import 'package:etoet/services/database/database.dart';
import 'package:etoet/views/emergency/emergency_marker.dart';
import 'package:etoet/views/emergency/sos_default_map.dart';
import 'package:etoet/services/map/friend/friend_marker_location.dart';
import 'package:etoet/services/map/geoflutterfire/geoflutterfire.dart';
import 'package:etoet/services/map/map_factory.dart' as etoet;
import 'package:etoet/services/map/marker/marker.dart';
import 'package:etoet/services/map/osrm/routing.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../database/firestore/firestore.dart';
import 'geocoding.dart';

/// This is the implementation of the [Map] interface using [GoogleMap].
///
/// # Functions:
/// - moveToCurrentLocation() - moves the map to the current location
/// - updateCurrentMapAddress() - update the current addressList that the map shows
/// - initializeMap() - initializes the map(move the map to current location, update addressList)
class GoogleMapImpl extends StatefulWidget implements etoet.Map {
  late LatLng _location = const LatLng(0, 0);
  late GoogleMapController _mapController;
  late StreamSubscription _locationSubscription;
  late StreamSubscription _databaseLocationSubscription;
  late Set<StreamSubscription> _friendsLocationSubscriptions;
  final Set<Marker> _markers = {};
  final Set<Marker> _friendsMarkers = {};
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
    address = await Geocoding.getAddress(await _mapController.getLatLng(
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
  late Future<LatLng> location = widget._getCurrentLocation();
  late BitmapDescriptor userIcon;
  final mapEmergencyUidLocation = <String, LatLng>{};
  late StreamSubscription emergencySubcription;

  void _initializeMap() async {
    devtools.log('_initializeMap', name: 'GoogleMap: _initializeMap');

    widget._friendsLocationSubscriptions =
        Realtime.syncFriendsLocation(widget.authUser!);

    // get location, update geocoding
    var currentLocation = await widget._getCurrentLocation();
    Routing.location = currentLocation;
    widget.address = await Geocoding.getAddress(currentLocation);

    // get user icon, draw marker
    var icon = await GoogleMapMarker.getIconFromUrl(widget.authUser!.photoURL ??
        'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg');
    userIcon = icon;
    widget._locationSubscription = widget._getLocationStream((position) {
      var location = LatLng(position.latitude, position.longitude);
      widget._location = location;
      Routing.location = location;
      widget._markers.removeWhere(
          (element) => element.markerId == MarkerId(widget.authUser!.uid));
      setState(() {
        widget._markers.add(Marker(
            markerId: MarkerId(widget.authUser!.uid),
            position: location,
            icon: icon));
      });
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
    }, 30);

    devtools.log('Finish _initializeMap', name: 'GoogleMap: _initializeMap');
  }

  /// Sync friend marker on map
  void syncFriendMarker() {
    for (var subcription in widget._friendsLocationSubscriptions) {
      subcription.onData((data) {
        data = data as DatabaseEvent;
        var lat =
            data.snapshot.child('location').child('latitude').value as double;
        var lng =
            data.snapshot.child('location').child('longitude').value as double;
        var friendLocation = Location(latitude: lat, longitude: lng);
        var friendId = data.snapshot.key;
        widget.authUser!.mapFriendUidLocation[friendId!] = friendLocation;
        updateFriendMarker(friendId);
        devtools.log('sync friend marker', name: 'GoogleMap: syncFriendMarker');
      });
    }
  }

  /// Update markers of all friends
  void updateFriendMarker(String friendId) async {
    var friendInfoList = widget.authUser?.friendInfoList ?? {};
    for (var friendInfo in friendInfoList) {
      if (friendId == friendInfo.uid) {
        var friendMarkerCreator = FriendMarker(
            context: context,
            friendInfo: friendInfo,
            polylines: widget._polylines);
        var location = widget.authUser?.mapFriendUidLocation[friendInfo.uid];
        var latLng = LatLng(location!.latitude, location.longitude);
        var friendMarker =
            await friendMarkerCreator.createFriendMarker(friendLatLng: latLng);
        widget._markers.removeWhere(
            (marker) => marker.markerId == MarkerId(friendInfo.uid));
        widget._friendsMarkers.removeWhere(
            (marker) => marker.markerId == MarkerId(friendInfo.uid));
        widget._friendsMarkers.add(friendMarker);
        setState(() {
          widget._markers.add(friendMarker);
        });
        devtools.log(
            'marker list: ${widget._markers.length}, displayName: ${friendInfo.displayName}, location: $latLng',
            name: 'GoogleMap: updateFriendMarker');
      }
    }
  }

  /// Update markers of nearby emergency signal
  void updateEmergencyMarker(
      {required String emergencyId,
      required String situationDetail,
      required String locationDescription}) async {
    var emergencyInfo = await Firestore.getUserInfo(emergencyId);
    var emergencyMarkerCreator = EmergencyMarker(
        context: context,
        emergencyInfo: emergencyInfo,
        polylines: widget._polylines,
        uid: emergencyId,
        locationDescription: locationDescription,
        situationDetail: situationDetail);
    var location = mapEmergencyUidLocation[emergencyId];
    var latLng = LatLng(location!.latitude, location.longitude);
    var emergencyMarker = await emergencyMarkerCreator.createEmergencyMarker(
        emergencyLatLng: latLng,
        helpButtonPressed: () {
          // remove and add new marker
          widget._markers.removeWhere(
              (marker) => marker.markerId == MarkerId(emergencyId));

          setState(() {});
        });
    widget._markers
        .removeWhere((marker) => marker.markerId == MarkerId(emergencyId));
    setState(() {
      widget._markers.add(emergencyMarker);
    });

    devtools.log(
        'marker list: ${widget._markers.length}, displayName: ${emergencyInfo.displayName}, location: $latLng',
        name: 'GoogleMap: updateEmergencyMarker');
  }

  void toEmergencyState() {
    // pause friend stream
    for (var subscription in widget._friendsLocationSubscriptions) {
      subscription.pause();
    }

    // remove friends markers
    widget._markers.removeWhere(
        (marker) => marker.markerId != MarkerId(widget.authUser!.uid));
    widget._polylines.clear();

    // subcription to listen to all public signal in radius
    var emergencyRadius = 20.0;
    emergencySubcription = GeoFlutterFire.querySignalInRadius(
        lat: widget._location.latitude,
        lng: widget._location.longitude,
        radius: emergencyRadius);

    // add emergency marker if there are nearby signal
    emergencySubcription.onData((data) {
      for (var doc in data) {
        doc = doc as DocumentSnapshot;
        // only get public emergency signal
        if (doc['isPublic'] == true) {
          var geoPoint = doc['position']['geopoint'] as GeoPoint;
          var emergencyLocation = LatLng(geoPoint.latitude, geoPoint.longitude);
          var emergencyId = doc['uid'] as String;
          var locationDescription = doc['locationDescription'] as String;
          var situationDetail = doc['situationDetail'] as String;
          mapEmergencyUidLocation[emergencyId] = emergencyLocation;
          updateEmergencyMarker(
            emergencyId: emergencyId,
            locationDescription: locationDescription,
            situationDetail: situationDetail,
          );
        }
      }
    });
    setState(() {});
  }

  void toDefaultState() {
    // resume friends stream
    for (var subscription in widget._friendsLocationSubscriptions) {
      subscription.resume();
    }
    emergencySubcription.cancel();

    // remove emergency markers
    widget._markers.removeWhere(
        (marker) => marker.markerId != MarkerId(widget.authUser!.uid));

    // add friend markers
    setState(() {
      widget._markers.addAll(widget._friendsMarkers);
    });
  }

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
      syncFriendMarker();
    });
  }

  @override
  void dispose() {
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
                markers: widget._markers,
                polylines: widget._polylines,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                onCameraMoveStarted: () {
                  setState(() {});
                  widget.updateCurrentMapAddress();
                },
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
              Positioned(
                bottom: 80,
                child: EmergencyDefaultMap(
                  toEmergencyState: toEmergencyState,
                  toDefaultState: toDefaultState,
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
