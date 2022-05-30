# Introduction
In this application, to show the name/address of the current map view of the top left corner of the screen, we use a flutter plugin called Geocoding. [[1]](https://pub.dev/packages/geocoding)

Geocoding is the term for the job of converting real life address or a name of a location to geographic coordinates such as longitude, latitude. The function that do the opposite thing which return the address from the location is called reverse geocoding.

# How to use
First import the plugin
```dart
import 'package:geocoding/geocoding.dart';
```
Then to convert a geographic value to placemark, run:
```dart
List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
```
The function is an async function, and it returns a list of possible placemark (but it usually return one placemark, only when the location is hard to get then it can return some alternative placemark)

From the placemark we can get it attributes which are:
- Country
- Locality
- Thoroughfare
- SubLocality
- PostalCode
- AdministrativeArea
- SubAdministrativeArea
- SubThoroughfare

# How it works
It uses the free Geocoding services provided by the iOS and Android platforms [[1]](/https://pub.dev/packages/geocoding). And to get the data correctly, people uses points to map the address. For the process of geocoding, the input will be used to classified into relative result or absolute result. The relative result return nothing because it does not know which location is given. And the absolute result return a coordinate [[2]](https://learn.g2.com/geocoding)

# Reference
1. Baseflow, Geocoding plugin on pub.dev, from https://pub.dev/packages/geocoding
2. Ramella, B. (n.d.). Geocoding 101: What is geocoding and how does it work? Learn Hub. Retrieved May 26, 2022, from https://learn.g2.com/geocoding 