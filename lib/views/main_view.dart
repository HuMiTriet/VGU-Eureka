import 'dart:async';

import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/map/map_factory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MainView extends StatefulWidget {
  @override
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final AuthUser authUser = AuthUser(
      uid: 'testUser123',
      isEmailVerified: true,
      phoneNumber: '+012345678',
      email: 'test123@gmail.com');
  late Map map;

  Timer? timer;

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

  @override
  void initState() {
    map = Map('GoogleMap', authUser);
    map.setContext(context);
    super.initState();
    hasLocationPermission();

    // run after build
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      setState(() {
        map.initializeMap();
        var screenWidth = MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio;
        var screenHeight = MediaQuery.of(context).size.height *
            MediaQuery.of(context).devicePixelRatio;
        map.updateScreenSize(screenWidth, screenHeight);
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        map.updateCurrentMapAddress();
      });
      timer?.cancel();
    });

    return Scaffold(
      body: Stack(
        children: <Widget>[
          map,
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 30.0, 10.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      shape: const CircleBorder(),
                      fixedSize: const Size(50, 50),
                    ),
                    child: const Icon(
                      Icons.account_box_rounded,
                      size: 24.0,
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        settingsRoute,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      shape: const CircleBorder(),
                      fixedSize: const Size(50, 50),
                    ),
                    child: const Icon(
                      Icons.settings,
                      size: 24.0,
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
            child: Text(map.address,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Color.fromARGB(104, 220, 155, 69))),
          ),
        ],
      ),
      floatingActionButton: Wrap(
        spacing: 105,
        alignment: WrapAlignment.center,
        children: <Widget>[
          FloatingActionButton(
              heroTag: 'goToFriendsFromMain',
              onPressed: () {},
              child: const Icon(Icons.group)),
          FloatingActionButton(
              heroTag: 'goToSOSFromMain',
              onPressed: () {},
              child: const Icon(Icons.add_alert)),
          FloatingActionButton(
            heroTag: 'getCurrentLocationFromMain',
            onPressed: () {
              map.moveToCurrentLocation();
            },
            child: const Icon(Icons.location_on),
          ),
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              FirebaseAuth.instance.signOut();
            },
            child: const Text('Sign out'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
