import 'package:etoet/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum MenuAction { signOut }

class MainView extends StatefulWidget {
  @override
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
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
      body: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(11.0551, 106.6657),
              zoom: 15,
            ),
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {},
            markers: <Marker>{
              const Marker(
                markerId: MarkerId('myMarker'),
                position: LatLng(11.0551, 106.6657),
                infoWindow: InfoWindow(
                  title: 'Vietnamese German University',
                  snippet: 'My Location',
                ),
                visible: true,
                icon: BitmapDescriptor.defaultMarker,
              ),
              const Marker(
                markerId: MarkerId('myMarker2'),
                position: LatLng(10.07, 106.01),
                infoWindow: InfoWindow(
                  title: 'My Location',
                  snippet: 'My Location',
                ),
                visible: true,
                icon: BitmapDescriptor.defaultMarker,
              ),
            },
            // polylines:
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(primary: Colors.orange, shape: const CircleBorder(), fixedSize: const Size(40, 40),),
                  child: Icon(
                    Icons.account_box_rounded,
                    size: 24.0,
                  )
              ),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(primary: Colors.orange, shape: const CircleBorder(), fixedSize: const Size(40, 40),),
                  child: Icon(
                    Icons.settings,
                    size: 24.0,
                  )
              ),
            ],
          ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     getRoad().then((road) {
      //       print(road.polylineEncoded);
      //       String encoded = road.polylineEncoded!;
      //       // decodeEncodedPolyline(encoded).forEach((latLng) {
      //       //   print(latLng);
      //       // });
      //       print(road.distance);
      //       print(road.duration);
      //       print(road.details);
      //       print(road.canDrawRoad);
      //       // road.polyline?.forEach((polyline) {
      //       //   print(polyline);
      //       // });
      //     });
      //   },
      //   child: Icon(Icons.directions),
      // ),
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
