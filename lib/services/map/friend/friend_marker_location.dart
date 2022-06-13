import 'dart:ui' as ui;

import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:etoet/services/map/geocoding.dart';
import 'package:etoet/services/map/osrm/routing.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../views/friend/chat_room_view.dart';
import '../../database/firestore/firestore_chat.dart';
import '../marker/marker.dart';

/// This class is used to create a marker for a friend
class FriendMarker {
  Routing routing = Routing.getInstance();
  late etoet.UserInfo friendInfo;
  late Future<BitmapDescriptor> friendIcon =
      GoogleMapMarker.getIconFromUrl(friendInfo.photoURL!);
  late Set<Polyline> polylines;
  late BuildContext context;
  late Function setState;

  late AuthUser user;

  Future<void> toFriendChatView() async {
    var chatroomUID = const Uuid().v4().toString();
    await FirestoreChat.createFriendChatroom(
        user.uid, friendInfo.uid, chatroomUID);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatRoomView(friendInfo)),
    );
  }



  FriendMarker({
    required this.friendInfo,
    required this.context,
    required this.polylines,
    required this.setState,
    required this.user,
  });
  Future<Marker> createFriendMarker({
    required LatLng friendLatLng,
  }) async {

    var location = await Geocoding.getAddress(friendLatLng);
    var isShowDirection = false;
    return Marker(
      markerId: MarkerId(friendInfo.uid),
      position: friendLatLng,
      icon: await friendIcon,
      infoWindow: InfoWindow(
        title: friendInfo.displayName,
        snippet: 'Tap to see friend\'s location',
      ),
      onTap: () {
        showModalBottomSheet(
            barrierColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: const BoxDecoration(
                  color: Color(0xFFffa858),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Spacer(),
                    Text(
                      friendInfo.displayName ?? 'Etoet User',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Text('Location: $location',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    const Spacer(),



                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xfff46135),
                            shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // fixedSize: const Size(320, 50),
                          ),
                          child: Text(
                            isShowDirection
                                ? 'Hide direction to ${friendInfo.displayName}'
                                : 'Show direction to ${friendInfo.displayName}',
                            style: const TextStyle(
                                fontWeight: ui.FontWeight.bold,
                                color: Colors.white),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            isShowDirection
                                ? {
                                    polylines.removeWhere((element) =>
                                        element.polylineId ==
                                        PolylineId(friendInfo.uid)),
                                    setState(),
                                  }
                                : {
                                    polylines.add(Polyline(
                                        polylineId: PolylineId(friendInfo.uid),
                                        visible: true,
                                        points: await routing
                                            .getPointsFromUser(friendLatLng),
                                        width: 5,
                                        color: Colors.blue)),
                                    setState(),
                                  };
                            isShowDirection = !isShowDirection;
                          },
                        ),
                        const Spacer(),

                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                            ),
                            onPressed: (){
                              toFriendChatView();
                            },
                            child: const IconTheme(
                              data: IconThemeData(
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.message,
                              ),
                            )),
                        const Spacer(),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              );
            });
      },
    );
  }
}
