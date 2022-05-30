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
  String? chatRoomId, messageId = "";
  String? myName, myProfilePic, myUserName, myEmail;
  Stream? messageStream;
  TextEditingController messageTextEditingController = TextEditingController();

  // getMyInfoFromSharedPreference() async {
  //   myName = await SharedPreferenceHelper().getDisplayName();
  //   myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
  //   myUserName = await SharedPreferenceHelper().getUserName();
  //   myEmail = await SharedPreferenceHelper().getUserEmail();
  //
  //   chatRoomId = getChatRoomIdByUsernames(widget.chatWithUsername, myUserName!);
  // }

  // getChatRoomIdByUsernames(String a, String b) {
  //   if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
  //     return "$b\_$a";
  //   } else {
  //     return "$a\_$b";
  //   }
  // }

  addMessage(bool sendClicked) {
    sendClicked = true;
    if (messageTextEditingController.text != "") {
      String message = messageTextEditingController.text;
      //Ts: TimeStamp
      var lastMessageTs = DateTime.now();
      Firestore.setMessage('35195569s468', message, user.uid);

      // //messageId
      // if (messageId == "") {
      //   //TODO: Fix
      //   messageId = randomAlphaNumeric(12);
      // }

      // DatabaseMethods()
      //     .addMessage(chatRoomId!, messageId!, messageInfoMap)
      //     .then((value) {
      //   Map<String, dynamic> lastMessageInfoMap = {
      //     "lastMessage": message,
      //     "lastMessageSendTs": lastMessageTs,
      //     "lastMessageSendBy": myUserName
      //   };

      // DatabaseMethods()
      //     .updateLastMessageSend(chatRoomId!, lastMessageInfoMap);

      if (sendClicked) {
        //remove the text in the message input field
        messageTextEditingController.text = "";

        //make the message id blank to get regenerated on next message send
        messageId = "";
      }
      // });
    }
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

  // getAndSetMessages() async {
  //TODO: Fix2
  //   messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
  //   setState(() {});
  // }

  // doThisOnLaunch() async {
  //TODO: Fix3
  //   await getMyInfoFromSharedPreference();
  //   getAndSetMessages();
  // }

  @override
  void initState() {
    super.initState();
    messageStream = Firestore.getMessageStream('35195569s468');
  }

  @override
  Widget build(BuildContext context) {
    user = context.watch<AuthUser>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedUser.displayName!),
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
                        // addMessage(false);
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
                        // addMessage(true);
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
}
