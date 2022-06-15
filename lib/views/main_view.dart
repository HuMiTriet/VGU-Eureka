import 'dart:convert';
import 'dart:developer' as developer show log;

import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:etoet/services/database/firestore/firestore.dart';
import 'package:etoet/services/database/firestore/firestore_emergency.dart';
import 'package:etoet/services/database/firestore/firestore_friend.dart';
import 'package:etoet/services/map/map_factory.dart' as etoet;
import 'package:etoet/services/notification/notification.dart';
import 'package:etoet/views/friend/chat_room_view.dart';
import 'package:etoet/views/friend/friend_view.dart';
import 'package:etoet/views/popup_sos_message/popupsos_message.dart';
import 'package:etoet/views/popup_sos_message/sos_received_bottom_bar.dart';
import 'package:etoet/views/signal/sos_signal_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_user.dart';
import 'emergency/sos_chat_hall_view.dart';

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
    FirestoreEmergency.getEmergencySignal(uid: authUser!.uid).then((value) => {
          authUser!.emergency = value,
        });

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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SOSChatHallView()),
                                  );
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SOSView(
                              uid: authUser!.uid,
                            ),
                          ),
                        );
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
      developer.log('resume message');
    } else {
      developer.log('message which opens app is null');
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
      developer.log('payload in object: $data');

      onClickNotificationRouting(data);
    }
  }

  void _handleMessage(RemoteMessage message) {
    developer.log('message comming while app is in background');

    onClickNotificationRouting(message.data);
  }

  void _handleForeGroundMessage(RemoteMessage message) {
    if (message.notification != null) {
      developer.log('received message: ${message.data}');

      switch (message.data['type']) {
        case 'publicAccepted':
          var helperInfo = etoet.UserInfo(
              uid: message.data['helperUID'],
              displayName: message.data['helperDisplayName'],
              email: message.data['helperEmail'],
              phoneNumber: message.data['helperPhoneNumber'],
              photoURL: message.data['helperPhotoUrl']);
          developer.log('show sos received message');
          showModalBottomSheet(
              barrierColor: Colors.transparent,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => SoSReceivedBottomSheet(
                    helperInfo: helperInfo,
                  ));
          setState(() {
            map.addHelperMarker(helperInfo: helperInfo);
          });
          break;
        case 'privateEmegency':
          showModalBottomSheet(
            barrierColor: Colors.transparent,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => PrivateDialog(
              title: message.data['situationDetail'],
              body: message.data['locationDescription'],
              helperUID: authUser!.uid,
              helpeeUID: message.data['helpeeUID'],
              helpeePhotoUrl: message.data['photoUrl'],
              context: context,
              helpeeDisplayName: message.data['displayName'],
            ),
          );
          break;

        default:
          NotificationHandler.display(message);
          break;
      }
    } else {
      developer.log('message is null');
    }
  }

  void onClickNotificationRouting(data) async {
    switch (data['type']) {
      case 'newFriend':
        showBarModalBottomSheet(
          //expand: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => const FriendView(),
        );
        break;
      case 'newMessage':
        // create user from payload data
        var sender = await Firestore.getUserInfo(data['senderUID']);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatRoomView(sender)),
        );
        break;
      case 'publicAccepted':
        var helperInfo = etoet.UserInfo(
            uid: data['helperUID'],
            displayName: data['helperDisplayName'],
            email: data['helperEmail'],
            phoneNumber: data['helperPhoneNumber'],
            photoURL: data['helperPhotoUrl']);
        showModalBottomSheet(
            // expand: false
            barrierColor: Colors.transparent,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => SoSReceivedBottomSheet(
                  helperInfo: helperInfo,
                ));
        setState(() {
          map.addHelperMarker(helperInfo: helperInfo);
        });
        break;

      case 'privateEmergency':
        showDialog(
          context: context,
          builder: (context) => PrivateDialog(
            title: data['displayName'] + "'s Private Alert",
            body: data['locationDescription'],
          ),
        );
        break;
    }
  }
}
