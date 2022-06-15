import 'package:etoet/views/friend/chat_room_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../services/database/firestore/firestore_chat.dart';

class PrivateDialog extends StatelessWidget {
  final String title;
  final String body;
  PrivateDialog({
    required this.title,
    required this.body,
    Key? key,
  }) : super(key: key);
  /* PrivateDialog({Key? key}) : super(key: key); */

  // set up the buttons
  final Widget sendmessageButton = ElevatedButton(
    onPressed: () {

    },

    style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    child: const Text('SEND MESSAGE'),
  );

  final Widget helpButton = ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
        primary: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    child: const Text('HELP'),
  );

  @override
  Widget build(BuildContext context) {
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
          const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/etoet-pe2022.appspot.com/o/images%2FDefault.png?alt=media&token=9d2d4b15-cf04-44f1-b46d-ab0f06ab2977'),
            radius: 25,
          ),
          Text(title),
          /* const Text('private helphelphelphelphelphelp' ), */
        ],
      ),
      content: Text(body),
      /* content: const Text('null'), */
      actions: [
        sendmessageButton,
        helpButton,
      ],
    );
  }
}

//  void toFriendChatView() async {
//    var chatroomUID = const Uuid().v4().toString();
//    await FirestoreChat.createFriendChatroom(
//        user.uid, widget.needHelpUser.uid, chatroomUID);
//    print('create chatroom complete');
//
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => ChatRoomView(widget.needHelpUser)),
//    );
//  }
//}
