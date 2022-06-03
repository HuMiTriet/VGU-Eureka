import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/database/firestore.dart';

class FirestoreChat extends Firestore {
  //Constructor
  FirestoreChat() : super();

  static Stream<QuerySnapshot> getMessageStream(String chatRoomUID) {
    Stream<QuerySnapshot> messageStream = Firestore.firestoreReference
        .collection('chatrooms')
        .doc(chatRoomUID)
        .collection('messages')
        .orderBy('ts', descending: true)
        .snapshots();
    return messageStream;
  }

  static Future<void> createFriendChatroom(
      String userUID1, String userUID2, String chatroomUID) async {
    final user1Ref = Firestore.firestoreReference
        .collection('users')
        .doc(userUID1)
        .collection('friends')
        .doc(userUID2);
    final user2Ref = Firestore.firestoreReference
        .collection('users')
        .doc(userUID2)
        .collection('friends')
        .doc(userUID1);

    var data1 = await user1Ref.get();
    var data2 = await user2Ref.get();

    if (data1.data()!['chatroomUID'] == null ||
        data2.data()!['chatroomUID'] == null) {
      user1Ref.set({'chatroomUID': chatroomUID}, SetOptions(merge: true));
      user2Ref.set({'chatroomUID': chatroomUID}, SetOptions(merge: true));
      Firestore.firestoreReference
          .collection('chatrooms')
          .doc(chatroomUID)
          .set({'user1UID': userUID1, 'user2UID': userUID2});
    }
  }

  static Future<String> getChatroomUID(String user1UID, String user2UID) async {
    var ref = await Firestore.firestoreReference
        .collection('users')
        .doc(user1UID)
        .collection('friends')
        .doc(user2UID)
        .get();

    return ref.data()!['chatroomUID'];
  }

  static void setMessage(String chatroomUID, String message, String senderUID) {
    var ts = Timestamp.now();
    final data = {'message': message, 'senderUID': senderUID, 'ts': ts};
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatroomUID)
        .collection('messages')
        .add(data);
  }
}
