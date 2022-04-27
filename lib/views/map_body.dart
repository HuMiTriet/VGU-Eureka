import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapImpl extends StatefulWidget {
  LatLng initialLocation = const LatLng(11.0551, 106.6657);
  late GoogleMapController _mapController;
  late StreamSubscription _locationSubscription;
  final Location _locationTracker = Location();
  Set<Marker> markersList = {};
  Set<Polyline> polylinesList = {};
  late GoogleMap googleMap;

  GoogleMapImpl({Key? key}) : super(key: key);

  void update() {}

  GoogleMapController getController() {
    return _mapController;
  }

  Future<LatLng> getCurrentLocation() async {
    var locationData = await Location().getLocation();
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  void updateCurrentLocation() async {
    initialLocation = await getCurrentLocation();
  }

  void updateLiveLocation() {
    _locationSubscription =
        _locationTracker.onLocationChanged.listen((locationData) {
      initialLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  void updateMap(LatLng location) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: location,
        zoom: 15.0,
      ),
    ));
  }

  void setMarkers(Set<Marker> markers) {
    markersList = markers;
  }

  void setPolylines(Set<Polyline> polylines) {
    polylinesList = polylines;
  }

  Set<Marker> getMarkers() {
    return markersList;
  }

  Set<Polyline> getPolylines() {
    return polylinesList;
  }

  @override
  State<StatefulWidget> createState() => _GoogleMapImplState();
}

class _GoogleMapImplState extends State<GoogleMapImpl> {
  @override
  void initState() {
    super.initState();
    widget.googleMap = GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.initialLocation,
        zoom: 15,
      ),
      onMapCreated: (controler) {
        widget._mapController = controler;
      },
      markers: widget.markersList,
      polylines: widget.polylinesList,
      // myLocationEnabled: true,
      zoomControlsEnabled: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.googleMap;
  }
}
