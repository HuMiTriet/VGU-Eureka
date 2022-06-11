import 'dart:convert';
import 'dart:developer';

import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:etoet/services/auth/user_info.dart';
import 'package:etoet/services/database/firestore.dart';
import 'package:etoet/services/map/map_factory.dart' as etoet;
import 'package:etoet/services/notification/notification.dart';
import 'package:etoet/views/friend/chat_room_view.dart';
import 'package:etoet/views/friend/friend_view.dart';
import 'package:etoet/views/signal/SOS_view.dart';
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
        future: Firestore.getFriendInfoList(authUser!.uid),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
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
        setupInteractedMessage();
      }
    });
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    var initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
      log('resume message');
    } else {
      log('message which opens app is null');
    }

    // app is in background but open
    // handle firebase messaging
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // app is in foreground
    // handle firebase messaging
    FirebaseMessaging.onMessage.listen(_handleForeGroundMessage);

    // handle onclick local push notification
    NotificationHandler.onNotifications.stream.listen(onClickNotification);
  }

  // foreground notification
  void onClickNotification(String? payload) {
    if (payload != null) {
      var data = json.decode(payload);
      log('payload in object: ${data}');

      onClickNotificationRouting(data);
    }
  }

  void _handleMessage(RemoteMessage message) {
    log('message comming while app is in background');

    onClickNotificationRouting(message.data);
  }

  void _handleForeGroundMessage(RemoteMessage message) {
    if (message.notification != null) {
      // if (ModalRoute.of(context)!.settings.name != null) {
      //   log('current route when receiving message: ${ModalRoute.of(context)!.settings.name}');
      //   print(ModalRoute.of(context)!.settings.name);
      // } else {
      //   log('current route is null');
      // }

      log('received message: ${message.data}');

      NotificationHandler.display(message);
    } else {
      log('message is null');
    }
  }

  void onClickNotificationRouting(data) {
    switch (data['type']) {
      case 'emegency':
        // go to emergency screen
        break;

      case 'newFriend':
        showBarModalBottomSheet(
          //expand: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => const FriendView(),
        );
        break;
      case 'newChat':
        // create user from payload data
        log('before creat auth user');
        var sender = UserInfo(
            uid: data['uid'],
            email: data['email'],
            photoURL: data['photoUrl'],
            displayName: data['displayName']);

        log('user:');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatRoomView(sender)),
        );
        log('push to chatroom');
        break;
      case 'sos':
        break;
    }
  }
}
