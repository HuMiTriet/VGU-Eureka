import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/database/firestore/firestore.dart';
import 'package:etoet/views/friend/friend_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:provider/provider.dart';

import '../../services/auth/auth_user.dart';
import '../../services/database/firestore/firestore_chat.dart';

class ChatRoomView extends StatefulWidget {
  // @override
  // const ChatRoomView({Key? key}) : super(key: key);

  final etoet.UserInfo selectedUser;

  ChatRoomView(@required this.selectedUser);

  @override
  State<ChatRoomView> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatRoomView> {
  bool isSameUserLastMessage = false;
  late AuthUser user;
  late String chatroomUID;
  String? myName, myProfilePic, myUserName, myEmail;
  late Stream<QuerySnapshot> messageStream;
  TextEditingController messageTextEditingController = TextEditingController();
  late int? messageLength;

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
    return Wrap(
      direction: Axis.horizontal,
      textDirection:
          (senderUID == user.uid) ? TextDirection.rtl : TextDirection.ltr,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            (senderUID == user.uid)
                ? user.photoURL!
                : widget.selectedUser.photoURL!,
          ),
          radius: 15,
        ),
        const SizedBox(
          width: 1,
        ),
        Text(timestampString),
      ],
    );
  }

  Widget chatMessageTile(String message, String senderUID, Timestamp timestamp,
      bool isSameUserLastMessage) {
    return Row(
      mainAxisAlignment: (senderUID == user.uid)
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Column(
            crossAxisAlignment: (senderUID == user.uid)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(24),
                    bottomRight: (senderUID == user.uid)
                        ? const Radius.circular(0)
                        : const Radius.circular(24),
                    topRight: const Radius.circular(24),
                    bottomLeft: (senderUID == user.uid)
                        ? const Radius.circular(24)
                        : const Radius.circular(0),
                  ),
                  color: Colors.blue,
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              avatarAndTime(senderUID, timestamp, isSameUserLastMessage)
            ]),
      ],
    );
  }

  // Widget chatMessages() {
  //   return
  // }

  @override
  Widget build(BuildContext context) {
    user = context.watch<AuthUser>();
    return FutureBuilder(
        future: FirestoreChat.getChatroomUID(user.uid, widget.selectedUser.uid),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.done) {
            chatroomUID = futureSnapshot.data as String;
            messageStream = FirestoreChat.getMessageStream(chatroomUID);

            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.selectedUser.photoURL!),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(widget.selectedUser.displayName!),
                  ],
                ),
                titleSpacing: 0,
              ),
              body: Container(
                child: Stack(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: messageStream,
                      builder: (context, snapshot) {
                        String? lastMessageUserUID = '';
                        //return Container();
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData == false ||
                            snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                                'No messages yet, chat to ${widget.selectedUser.displayName}!'),
                          );
                        }
                        messageLength = snapshot.data?.docs.length;
                        return ListView.builder(
                            padding: const EdgeInsets.only(bottom: 80, top: 16),
                            itemCount: snapshot.data!.docs.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              var messageInfo = snapshot.data!.docs
                                  .elementAt(index)
                                  .data() as Map<String, dynamic>;
                              var message = messageInfo['message'];
                              var senderUID = messageInfo['senderUID'];
                              Timestamp timestamp = messageInfo['ts'];
                              if (senderUID == lastMessageUserUID) {
                                isSameUserLastMessage = true;
                                lastMessageUserUID = senderUID;
                              } else {
                                isSameUserLastMessage = false;
                                lastMessageUserUID = senderUID;
                              }
                              return chatMessageTile(message, senderUID,
                                  timestamp, isSameUserLastMessage);
                              // DocumentSnapshot ds = snapshot.data!.docs[index];
                              // return chatMessageTile(
                              //     ds['message'], user.uid == ds['senderUid']);
                            });
                      },
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.black.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextField(
                              controller: messageTextEditingController,
                              onChanged: (value) {},
                              //border: InputBorder.none to get rid of underline things
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type a message!',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withOpacity(0.6)),
                              ),
                              style: const TextStyle(color: Colors.white),
                            )),
                            GestureDetector(
                              onTap: () {
                                FirestoreChat.setMessage(
                                  chatroomUID: chatroomUID,
                                  message: messageTextEditingController.text,
                                  senderUID: user.uid,
                                );
                                messageTextEditingController.clear();
                              },
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
