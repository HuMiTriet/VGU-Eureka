import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/map/map_factory.dart';
import 'package:etoet/views/profile/profile_page.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_user.dart';

class MainView extends StatefulWidget {
  final AuthUser user;

  @override
  const MainView({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late Map map;

  @override
  void initState() {
    super.initState();
    map = Map('GoogleMap', widget.user);
    map.context = context;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          map,
          Padding(
            padding: const EdgeInsets.fromLTRB(200.0, 30.0, 10.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(user: widget.user),
                        ),
                      );
                    },
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
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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

  @override
  void dispose() {
    super.dispose();
  }
}
