import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/auth/auth_user.dart';

class SOSChatRoomView extends StatefulWidget {
  // @override
  // const ChatRoomView({Key? key}) : super(key: key);

  final etoet.UserInfo selectedUser;

  SOSChatRoomView(@required this.selectedUser);

  @override
  State<SOSChatRoomView> createState() => _SOSChatScreenState();
}

class _SOSChatScreenState extends State<SOSChatRoomView> {

  bool isSameUserLastMessage = false;
  late AuthUser user;
  late String chatroomUID;
  String? myName, myProfilePic, myUserName, myEmail;
  late Stream<QuerySnapshot> messageStream;
  TextEditingController messageTextEditingController = TextEditingController();
  late int? messageLength;

  late String userImageUrl;

  @override
  void initState() {
    super.initState();
    // asyncMethod();
  }

  Widget avatarAndTime(
      String senderUID, Timestamp timestamp, bool isSameUserLastMessage) {
    DateTime myDateTime = timestamp.toDate();
    var timestampString =
        myDateTime.hour.toString() + ':' + myDateTime.minute.toString();
    if (isSameUserLastMessage == true) {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }

    return Wrap(direction: Axis.horizontal, children: [
      Container(
        margin: const EdgeInsets.only(left: 10, top: 5, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection:
          (senderUID == user.uid) ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Row(children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  (senderUID == user.uid)
                      ? userImageUrl
                      : widget.selectedUser.photoURL!,
                ),
                radius: 15,
              ),
            ]),
            const SizedBox(
              width: 10,
            ),
            Text(timestampString),
          ],
        ),
      ),
    ]);
  }

  Widget chatMessageTile(String message, String senderUID, Timestamp timestamp,
      bool isSameUserLastMessage) {
    return Column(
      crossAxisAlignment: (senderUID == user.uid)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: (senderUID == user.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight: (senderUID == user.uid)
                      ? Radius.circular(0)
                      : Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: (senderUID == user.uid)
                      ? Radius.circular(24)
                      : Radius.circular(0),
                ),
                color: Colors.blue,
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
            avatarAndTime(senderUID, timestamp, isSameUserLastMessage),
          ],
        ),
      ],
    );
  }

  // Widget chatMessages() {
  //   return
  // }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS Chat room'),
      ),
    );
  }

}