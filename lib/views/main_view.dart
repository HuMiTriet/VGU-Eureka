import 'package:etoet/constants/routes.dart';
import 'package:etoet/views/map_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

enum MenuAction { signOut }

class MainView extends StatefulWidget {
  @override
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  GoogleMapImpl map = GoogleMapImpl();
  Future<bool> hasLocationPermission() async {
    return await Location().requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        return true;
      } else if (granted == PermissionStatus.deniedForever) {
        return false;
      } else {
        Location().requestPermission().then((granted) {
          if (granted == PermissionStatus.granted) {
            return true;
          } else if (granted == PermissionStatus.deniedForever) {
            return false;
          } else {
            return false;
          }
        });
      }
      return false;
    });
  }

  @override
  void initState() {
    super.initState();
    hasLocationPermission();
    map = GoogleMapImpl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI here'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.signOut:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.signOut,
                  child: Text('Sign out'),
                )
              ];
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          map,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    shape: const CircleBorder(),
                    fixedSize: const Size(40, 40),
                  ),
                  child: Icon(
                    Icons.account_box_rounded,
                    size: 24.0,
                  )),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    shape: const CircleBorder(),
                    fixedSize: const Size(40, 40),
                  ),
                  child: Icon(
                    Icons.settings,
                    size: 24.0,
                  )),
            ],
          ),
        ],
      ),
      floatingActionButton: Wrap(
        spacing: 105,
        alignment: WrapAlignment.center,
        children: <Widget>[
          FloatingActionButton(
              onPressed: () {}, child: const Icon(Icons.group)),
          FloatingActionButton(
              onPressed: () {}, child: const Icon(Icons.add_alert)),
          FloatingActionButton(
            onPressed: () async {
              map.updateCurrentLocation();
              map.updateMap(await map.getCurrentLocation());
              map.updateLiveLocation();
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
