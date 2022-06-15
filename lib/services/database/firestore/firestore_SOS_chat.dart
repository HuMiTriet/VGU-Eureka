import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'firestore.dart';

class FirestoreSOSChat{

  //Constructor
  FirestoreSOSChat(){}

  static Stream<QuerySnapshot> getMessageStream(String chatroomUID) {
    Stream<QuerySnapshot> messageStream = Firestore.firestoreReference
        .collection('emergencies-chatrooms')
        .doc(chatroomUID)
        .collection('messages')
        .orderBy('ts', descending: true)
        .snapshots();
    return messageStream;
  }


  static Future<String> oldSOSChatroom(
      String user1UID, String user2UID) async {
    var data1 = await Firestore.firestoreReference
        .collection('emergencies-chatrooms')
        .where('user1UID', isEqualTo: user1UID)
        .where('user2UID', isEqualTo: user2UID)
        .get();

    //Another case, the users UID position got switched
    //TODO: Maybe change the field in chatrooms to arrays, it makes more sense when checking
    var data2 = await Firestore.firestoreReference
        .collection('emergencies-chatrooms')
        .where('user1UID', isEqualTo: user2UID)
        .where('user2UID', isEqualTo: user1UID)
        .get();

    if (data1.docs.isNotEmpty) {
      String oldChatroomUID = data1.docs.elementAt(0).data()['chatroomUID'];
      print('old SOS chatroom detected! chatroom UID:' + oldChatroomUID);
      return oldChatroomUID;
    }
    if (data2.docs.isNotEmpty) {
      String oldChatroomUID = data2.docs.elementAt(0).data()['chatroomUID'];
      print('old SOS chatroom detected! chatroom UID:' + oldChatroomUID);
      return oldChatroomUID;
    }

    return '';
  }

  static Future<void> createSOSChatroom(
      String userUID1, String userUID2, String chatroomUID) async {
    final user1Ref = Firestore.firestoreReference
        .collection('users')
        .doc(userUID1)
        .collection('SOS_participant')
        .doc(userUID2);
    final user2Ref = Firestore.firestoreReference
        .collection('users')
        .doc(userUID2)
        .collection('SOS_participant')
        .doc(userUID1);

    var data1 = await user1Ref.get();
    var data2 = await user2Ref.get();


    //Check if there is already a chatroom when two user unfriended
    var oldChatroomUID = await oldSOSChatroom(userUID1, userUID2);
    if (oldChatroomUID.isNotEmpty) {
      user1Ref.set({'chatroomUID': oldChatroomUID}, SetOptions(merge: true));
      user2Ref.set({'chatroomUID': oldChatroomUID}, SetOptions(merge: true));
      return;
    }

    if (!data1.exists|| !data2.exists) {
      user1Ref.set({'chatroomUID': chatroomUID, 'participantUID': userUID2}, SetOptions(merge: true));
      user2Ref.set({'chatroomUID': chatroomUID, 'participantUID': userUID1}, SetOptions(merge: true));
      Firestore.firestoreReference
          .collection('emergencies-chatrooms')
          .doc(chatroomUID)
          .set({
        'user1UID': userUID1,
        'user2UID': userUID2,
        'chatroomUID': chatroomUID
      });
    }
  }


  static Future<String> getChatroomUID(String user1UID, String user2UID) async {
    var ref = await Firestore.firestoreReference
        .collection('users')
        .doc(user1UID)
        .collection('SOS_participant')
        .doc(user2UID)
        .get();

    return ref.data()!['chatroomUID'];
  }


  static void setMessage({
    required String chatroomUID,
    required String message,
    required String senderUID,
  }) {
    var ts = Timestamp.now();
    final data = {
      'message': message,
      'senderUID': senderUID,
      'ts': ts
    };
    FirebaseFirestore.instance
        .collection('emergencies-chatrooms')
        .doc(chatroomUID)
        .collection('messages')
        .add(data);
  }

  static Future<Set<etoet.UserInfo>> getSOSChatHallParticipant(
      String userUID) async {
    var ref = await Firestore.firestoreReference
        .collection('users')
        .doc(userUID)
        .collection('SOS_participant')
        .get();

    var SOSParticipantList = <etoet.UserInfo>{};


    for (var i = 0; i < ref.docs.length; ++i) {
      // var source =
      // pendingFriendRequestData.metadata.isFromCache ? 'cache' : 'server';
      // print('Pending fetched from $source');
      var data = ref.docs.elementAt(i).data();

      var SOSParticipantInfo = await Firestore.getUserInfo(data['participantUID']);
      SOSParticipantList.add(SOSParticipantInfo);
    }

    return SOSParticipantList;

  }


}