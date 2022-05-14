import 'dart:async';
import 'dart:developer' as devtools show log;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/database/database.dart';
import 'package:etoet/services/map/map_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as loc;

/// This is the implementation of the [Map] interface using [GoogleMap].
///
/// # Functions:
/// - moveToCurrentLocation() - moves the map to the current location
/// - updateCurrentMapAddress() - shows the current addressList that the map shows
/// - updateScreenSize() - updates the screen size of the device
/// - initializeMap() - initializes the map(move the map to current location, update addressList)
class GoogleMapImpl extends StatefulWidget implements Map {
  late BuildContext context;
  late LatLng _location = const LatLng(11.0551, 106.6657);
  late GoogleMapController? _mapController;
  late StreamSubscription _locationSubscription;
  // final loc.Location _locationTracker = loc.Location();
  Set<Marker> _markersList = {};
  Set<Polyline> _polylinesList = {};
  late num deviceWidth;
  late num deviceHeight;
  List<String> addressList = ['', '', '', '', '', '', '', ''];
  late GoogleMap googleMap;

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
    devtools.log('initialize map', name: 'initializeMap');
    var currentLocation = await _getCurrentLocation();
    authUser.location.latitude = currentLocation.latitude;
    authUser.location.longitude = currentLocation.longitude;
    _moveMap(currentLocation);
    _updateCurrentAddress(currentLocation);
    updateCurrentMapAddress();
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
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: TextStyle(fontSize: 25.0, color: Colors.white),
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

  void updateFriendsLocation() async {
    final markerIcon = await getBytesFromCanvas('FRIEND');
    final anya = await getBytesFromAsset('assets/images/Anya.png', 100);
    final loid = await getBytesFromAsset('assets/images/Loid.png', 100);
    final yor = await getBytesFromAsset('assets/images/Yor.png', 100);
    _markersList = {
      Marker(
        markerId: const MarkerId('friend'),
        position: const LatLng(
          10.7878,
          106.7051,
        ),
        // icon: BitmapDescriptor,
        icon: BitmapDescriptor.fromBytes(loid),
        onTap: () {
          print('Loid');
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Loid is here'),
                    content: Text('Need to help with something'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ));
        },
      ),
      Marker(
        markerId: const MarkerId('friend1'),
        position: const LatLng(
          10.7288,
          106.7188,
        ),
        icon: BitmapDescriptor.fromBytes(yor),
        onTap: () {
          print('Yor');
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Yor is here'),
                    content: Text('Need to help with something'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ));
        },
      ),
      Marker(
        markerId: MarkerId('friend3'),
        position: LatLng(
          11.0551,
          106.6657,
        ),
        icon: BitmapDescriptor.fromBytes(anya),
        onTap: () {
          print('Anya');
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Anya'),
                    content: Text('Need to help with something'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ));
        },
      ),
      Marker(
          markerId: const MarkerId('friend4'),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          position: const LatLng(11.0566, 106.6687),
          onTap: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text('Friend'),
                      content: Text('My car has no gas. Please help me!'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ));
          }),
    };
    devtools.log('update markers of friends', name: 'updateFriendsLocation');
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
        name: 'GoogleMap: _updateGeocoding');
  }

  Future<LatLng> _getCurrentLocation() async {
    // var locationData = await loc.Location().getLocation();
    var locationDataGeolocator = await Geolocator.getCurrentPosition();
    _location = LatLng(
        locationDataGeolocator.latitude, locationDataGeolocator.longitude);
    devtools.log('locationData: $locationDataGeolocator',
        name: 'GoogleMap: _getCurrentLocation');
    return _location;
  }

  void _updateLiveLocation() {
    // _locationSubscription =
    //     _locationTracker.onLocationChanged.listen((locationData) {
    //   // devtools.log('locationData: $locationData', name: '_updateLiveLocation');
    //   _location = LatLng(locationData.latitude!, locationData.longitude!);
    // });
    _locationSubscription = Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high, distanceFilter: 1))
        .listen((position) {
      _location = LatLng(position.latitude, position.longitude);
      authUser.location.latitude = position.latitude;
      authUser.location.longitude = position.longitude;
      updateUserLocation(authUser);
      devtools.log('locationData: $position',
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
  }

  @override
  void dispose() {
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
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        widget.updateFriendsLocation();
      });
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
            // onCameraMove: (value) {
            //   widget._updateCurrentAddress(value.target);
            // },
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
