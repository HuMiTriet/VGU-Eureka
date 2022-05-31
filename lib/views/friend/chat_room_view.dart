import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/database/firestore.dart';
import 'package:etoet/views/friend/friend_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:provider/provider.dart';

import '../../services/auth/auth_user.dart';

class ChatRoomView extends StatefulWidget {
  // @override
  // const ChatRoomView({Key? key}) : super(key: key);

  final etoet.UserInfo selectedUser;
  ChatRoomView(@required this.selectedUser);

  @override
  State<ChatRoomView> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatRoomView> {
  late AuthUser user;
  String chatroomUID = 'aaaaaaa';
  String? myName, myProfilePic, myUserName, myEmail;
  Stream? messageStream;
  TextEditingController messageTextEditingController = TextEditingController();


  @override
  void initState() {
    super.initState();
    // asyncMethod();
    // messageStream = Firestore.getMessageStream('35195569s468');
  }


  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomRight: sendByMe ? Radius.circular(0) : Radius.circular(24),
              topRight: Radius.circular(24),
              bottomLeft: sendByMe ? Radius.circular(24) : Radius.circular(0),
            ),
            color: Colors.blue,
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, AsyncSnapshot snapshot) {
        return Container();
        // return snapshot.hasData
        //     ? ListView.builder(
        //         padding: EdgeInsets.only(bottom: 80, top: 16),
        //         itemCount: snapshot.data.docs.length,
        //         reverse: true,
        //         itemBuilder: (context, index) {
        //           DocumentSnapshot ds = snapshot.data.docs[index];
        //           return chatMessageTile(
        //               ds['message'], user.uid == ds['senderUid']);
        //         })
        //     : Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    user = context.watch<AuthUser>();
    return FutureBuilder(
      future: Firestore.getChatroomUID(user.uid, widget.selectedUser.uid),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done)
          {
            chatroomUID = snapshot.data as String;

            return Scaffold(
              appBar: AppBar(
                title: Text(widget.selectedUser.displayName!),
                bottom: PreferredSize(
                    preferredSize: Size.zero,
                    child: Text(chatroomUID)),
              ),
              body: Container(
                child: Stack(
                  children: [
                    chatMessages(),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.black.withOpacity(0.8),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextField(
                                  controller: messageTextEditingController,
                                  onChanged: (value) {
                                  },
                                  //border: InputBorder.none to get rid of underline things
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Type a message!",
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white.withOpacity(0.6)),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                )),
                            GestureDetector(
                              onTap: () {
                                Firestore.setMessage('35195569s468',
                                    messageTextEditingController.text, user.uid);
                                messageTextEditingController.clear();
                              },
                              child: Icon(
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
          }
        else
          {
            return const CircularProgressIndicator();
          }
      }
    );
  }
}
