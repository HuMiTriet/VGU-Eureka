# Introduction

To show the map on the main screen of application, our team use the Google Cloud Platform [[1]](https://cloud.google.com/). It offers many services such as google map, routing, cloud storage, geocoding, etc. But in this project we only use Map SDK for Android and IOS with Map Javascript for website beacause they are free to use. While the routing and geocoding function of google cloud platform is useful, it is not free to use, and cost about 5-10 USD per 1000 requests.

Beside showing the google map, our team need to implement some other functions related to the map such as getting the device location, generating a road from two points, showing the name of the place on the current map view. These tasks are done using the [following plugins](#other-plugins-using-with-google-map).

# How to use

- First import the plugin:

```dart
import 'package:google_maps_flutter/google_maps_flutter.dart';
```

- To create a map, build the GoogleMap widget and provide the required parameter or changing some parameter to make the map function as needed.

```dart
GoogleMap(
    initialCameraPosition: CameraPosition(target: LatLng(0,0),zoom: 15),
    onMapCreated: (controler) {
        mapController = controler;
    },
    markers: markers,
    polylines: polylines,
);
```

# Map Functions

## Default and SOS Map Switch

There is a button to switch the state of the map to change from Default map to the SOS map

- In the default map, the user can see all the friends' location.
- In the SOS map, all the friends' icons are cleared and the user can see all emergency signal in the radius set by the user in the setting screen.

## Map Controller

When create the GoogleMap, a controller for the map is created. With it, we can perform some functions, for example:

1. Move the camera view to a location on the map.
2. Set the map style(default, terrain, satelite).
3. Get the zoom level.
4. Get the current location of the map view.

## Markers

Markers are icons on the map that we can tap and run some functions. In the application, markers are used to represent the user location, friends' location on the map, and emergency signals.

When tap on a friend's icon, a dialog on the bottom will be showed and the user can see the friend's name, and name of the location or tap the 'show direction to {friend display name}' to draw a road to the friend.

In the SOS Map, markers are the nearby emergency signal. When the user tap on it, information about the emergency will be showed.

### How to use

To show custom icon using an image, first the image need to be converted to byte from an URL. Then create a marker as follow:

```dart
var location = LatLng(0, 0);
var icon = iconAsByte;
Marker(
    markerId: MarkerId('MarkerId'),
    position: location,
    icon: BitmapDescriptor.fromBytes(icon),
    );
```

## Polyines

To show a road on the google map, polyline class is used. A polyline is draw using a list of LatLng

### How to use

To create a polyline, it need a list of LatLng to draw multiple lines through and create a polyline.

```dart
var points = List<LatLng>{}
Polyline(
    polylineId: PolylineId('PolylineId'),
    visible: true,
    points: points,
    width: 5,
    color: Colors.blue,
    );
```

## LatLng

LatLng is a class to represent a point on the map using latitude and longitude.

### How to use

Create a LatLng as follow:

```dart
var point = LatLng(0, 0);
```

# Other plugins using with Google Map

## [Routing](./osrm_routing.md): To generate a road from two points

## [Geolocator](./location.md): To get the device location

## [Geocoding](./geocoding.md): To show the name of the location of the current map view

# References

1. Alphabet, Google Cloud Platform, from https://cloud.google.com/
