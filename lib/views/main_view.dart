import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:etoet/services/database/firestore/firestore.dart';
import 'package:etoet/services/database/firestore/firestore_emergency.dart';
import 'package:etoet/services/database/firestore/firestore_friend.dart';
import 'package:etoet/services/map/map_factory.dart' as etoet;
import 'package:etoet/services/notification/notification.dart';
import 'package:etoet/views/friend/friend_view.dart';
import 'package:etoet/views/signal/sos_signal_screen.dart';
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(profileRoute);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
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
                              primary: Colors.white,
                              shape: const CircleBorder(),
                              fixedSize: const Size(50, 50),
                            ),
                            child: Image.asset(
                              'assets/images/SettingButton.png',
                              width: 100,
                              height: 70,
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
                      backgroundColor: Colors.white,
                      child: Image.asset(
                          'assets/images/ShowListFriendButton.png')),
                  SizedBox(
                    height: 90.0,
                    width: 80.0,
                    child: FittedBox(
                      child: FloatingActionButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.red,
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
                          child: Image.asset(
                            'assets/images/SOSButton.png',
                          )),
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: 'getCurrentLocationFromMain',
                    onPressed: () {
                      map.moveToCurrentLocation();
                    },
                    backgroundColor: Colors.white,
                    child: Image.asset('assets/images/Re-locateButton.png'),
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
          if (dataType == 'emegency') {
            showDialog(
                context: context,
                builder: (context) {
                  var content = event.notification!.body;
                  var title = event.notification!.title;
                  return AlertDialog(
                    title: Text(title ?? 'Emergency alert'),
                    content: Text(content ?? 'null'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Accept'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Reject'),
                      )
                    ],
                  );
                });
          }
        });
      }
    });
  }
}
