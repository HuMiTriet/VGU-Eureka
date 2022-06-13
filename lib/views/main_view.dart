import 'dart:developer' as developer show log;
import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:etoet/services/database/firestore/firestore.dart';
import 'package:etoet/services/database/firestore/firestore_friend.dart';
import 'package:etoet/services/map/map_factory.dart' as etoet;
import 'package:etoet/services/notification/notification.dart';
import 'package:etoet/views/emergency/sos_dialog.dart';
import 'package:etoet/views/friend/friend_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_user.dart';

class MainView extends StatefulWidget {
  @override
  const MainView({
    Key? key,
  }) : super(key: key);

  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  late etoet.Map map;
  late AuthUser? authUser;

  @override
  Widget build(BuildContext context) {
    authUser = context.watch<AuthUser?>();

    return FutureBuilder(
        future: FirestoreFriend.getFriendInfoList(authUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var friendInfoList = snapshot.data as Set<etoet.UserInfo>;
            authUser!.friendInfoList.clear();
            for (var friendInfo in friendInfoList) {
              authUser?.friendInfoList.add(friendInfo);
            }
            return Scaffold(
              body: Stack(
                children: <Widget>[
                  map,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(200.0, 30.0, 10.0, 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(profileRoute);
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

                        const SizedBox(
                          height: 20,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(profileRoute);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  shape: const CircleBorder(),
                                  fixedSize: const Size(50, 50),
                                ),
                                child: const Icon(
                                  Icons.message_outlined,
                                  size: 24.0,
                                )),
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                      heroTag: 'goToFriendsFromMain',
                      onPressed: () {
                        showBarModalBottomSheet(
                          //expand: true,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const FriendView(),
                        );
                      },
                      child: const Icon(Icons.group)),
                  FloatingActionButton(
                      heroTag: 'goToSOSFromMain',
                      onPressed: () {
                        Navigator.of(context).pushNamed(sosRoute);
                      },
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
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    map = etoet.Map('GoogleMap');
    map.context = context;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var token = await NotificationHandler.notificatioToken;
      if (token == null) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                  title: Text('Can not retreive device token'));
            });
      } else {
        Firestore.setFcmTokenAndNotificationStatus(
            uid: authUser!.uid, token: token);
        FirebaseMessaging.onMessage.listen((event) {
          var dataType = event.data['type'];
          if (dataType == 'privateEmegency') {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.close),
                                color: Colors.grey,
                                iconSize: 25,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          const Text('Emergency'),
                        ],
                      ),
                      content: const Text('I need help!!!!'
                          '\nI want my mom back.'
                          ' This app is so wonderful.'),
                      /* actions: [ */
                      /*   sendmessageButton, */
                      /*   helpButton, */
                      /* ], */
                    ));
          }
        });
      }
    });
  }
}
