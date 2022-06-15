import 'package:etoet/services/auth/user_info.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../services/database/firestore/firestore_chat.dart';
import '../friend/chat_room_view.dart';

class PrivateDialog extends StatelessWidget {
  final String title;
  final String body;
  final String helperUID;
  final String helpeeUID;
  final String helpeeDisplayName;
  String helpeePhotoUrl;
  final BuildContext context;

  PrivateDialog({
    required this.title,
    required this.body,
    required this.helperUID,
    required this.helpeeUID,
    required this.helpeeDisplayName,
    required this.helpeePhotoUrl,
    required this.context,
    Key? key,
  }) : super(key: key);
  /* PrivateDialog({Key? key}) : super(key: key); */
  void toFriendChatView() async {
    var chatroomUID = const Uuid().v4().toString();
    await FirestoreChat.createFriendChatroom(helperUID, helpeeUID, chatroomUID);

    var helpee = UserInfo(
      uid: helpeeUID,
      displayName: helpeeDisplayName,
      photoURL: helpeePhotoUrl,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatRoomView(helpee)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (helpeePhotoUrl == 'undefined') {
      helpeePhotoUrl =
          'https://firebasestorage.googleapis.com/v0/b/etoet-pe2022.appspot.com/o/images%2FDefault.png?alt=media&token=9d2d4b15-cf04-44f1-b46d-ab0f06ab2977';
    }

    return AlertDialog(
      title: Column(
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
          CircleAvatar(
            backgroundImage: NetworkImage(
              helpeePhotoUrl,
            ),
            radius: 25,
          ),
          Text(title),
          /* const Text('private helphelphelphelphelphelp' ), */
        ],
      ),
      content: Text(body),
      /* content: const Text('null'), */
      actions: [
        ElevatedButton(
          onPressed: () {
            toFriendChatView();
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              textStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          child: const Text('SEND MESSAGE'),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              primary: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              textStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          child: const Text('HELP'),
        ),
      ],
    );
  }
}
