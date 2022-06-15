import 'package:etoet/services/database/firestore/firestore_SOS_chat.dart';
import 'package:etoet/views/emergency/sos_chat_room_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:uuid/uuid.dart';

import '../../services/auth/auth_user.dart';

class SOSChatHallView extends StatefulWidget{
  @override
  const SOSChatHallView({Key? key}) : super(key: key);

  @override
  _SOSChatHallViewState createState() => _SOSChatHallViewState();
  
}

class _SOSChatHallViewState extends State<SOSChatHallView> {
  late AuthUser user;
  late Set<etoet.UserInfo> SOSparticipantList;
  
  
  @override
  Widget build(BuildContext context) {
    user = context.watch<AuthUser>();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Chat Hall'),
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
      ),
      body: FutureBuilder(
        future: FirestoreSOSChat.getSOSChatHallParticipant(user.uid),
        builder: (context, snapshot){
          if(!snapshot.hasData) // Loading waiting for Data
            {
              return const CircularProgressIndicator();
            }
          else
            {
              SOSparticipantList = snapshot.data as Set<etoet.UserInfo>;
              if(SOSparticipantList.length == 0)
                {
                  return Center(
                    child: Text('No SOS Chat yet'),
                  );
                }
              return ListView.builder(
                itemCount: SOSparticipantList.length,
                  itemBuilder: (context, index){
                   return ListTile(
                     leading: CircleAvatar(
                       backgroundImage: NetworkImage(
                           SOSparticipantList
                               .elementAt(index)
                               .photoURL!),
                     ),
                     title: Text(
                       SOSparticipantList
                           .elementAt(index)
                           .displayName!,
                     ),
                     subtitle: Text(
                       SOSparticipantList.elementAt(index).email!,
                     ),

                     //To SOS chat view
                     onTap: ()
                     {
                       toSOSChatView(index);
                     },
                   );
                  }
              );
            }
        },
      ),
    );
  }

  void toSOSChatView(int index) async {
    var selectedUser = SOSparticipantList.elementAt(index);
    var chatroomUID = const Uuid().v4().toString();
    await FirestoreSOSChat.createSOSChatroom(
        user.uid, selectedUser.uid, chatroomUID);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SOSChatRoomView(selectedUser)),
    );
  }
  
}