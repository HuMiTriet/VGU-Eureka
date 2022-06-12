import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/database/firestore/firestore.dart';

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

    //Check if there is already a chatroom when two user unfriended
    var oldChatroomUID = await oldFriendChatroom(userUID1, userUID2);
    if (oldChatroomUID.isNotEmpty) {
      user1Ref.set({'chatroomUID': oldChatroomUID}, SetOptions(merge: true));
      user2Ref.set({'chatroomUID': oldChatroomUID}, SetOptions(merge: true));
      return;
    }

    if (data1.data()!['chatroomUID'] == null ||
        data2.data()!['chatroomUID'] == null) {
      user1Ref.set({'chatroomUID': chatroomUID}, SetOptions(merge: true));
      user2Ref.set({'chatroomUID': chatroomUID}, SetOptions(merge: true));
      Firestore.firestoreReference
          .collection('chatrooms')
          .doc(chatroomUID)
          .set({
        'user1UID': userUID1,
        'user2UID': userUID2,
        'chatroomUID': chatroomUID
      });
    }
  }

  static Future<String> oldFriendChatroom(
      String user1UID, String user2UID) async {
    var data1 = await Firestore.firestoreReference
        .collection('chatrooms')
        .where('user1UID', isEqualTo: user1UID)
        .where('user2UID', isEqualTo: user2UID)
        .get();

    //Another case, the users UID position got switched
    //TODO: Maybe change the field in chatrooms to arrays, it makes more sense when checking
    var data2 = await Firestore.firestoreReference
        .collection('chatrooms')
        .where('user1UID', isEqualTo: user2UID)
        .where('user2UID', isEqualTo: user1UID)
        .get();

    if (data1.docs.isNotEmpty) {
      String oldChatroomUID = data1.docs.elementAt(0).data()['chatroomUID'];
      print('old chatroom detected! chatroom UID:' + oldChatroomUID);
      return oldChatroomUID;
    }
    if (data2.docs.isNotEmpty) {
      String oldChatroomUID = data2.docs.elementAt(0).data()['chatroomUID'];
      print('old chatroom detected! chatroom UID:' + oldChatroomUID);
      return oldChatroomUID;
    }

    return '';
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

  static void setMessage({
    required String chatroomUID,
    required String message,
    required String senderUID,
    required String senderEmail,
    required String senderPhoneNumber,
    required String senderDisplayName,
    required String senderPhotoURL,
  }) {
    var ts = Timestamp.now();
    final data = {
      'message': message,
      'senderUID': senderUID,
      'senderEmail': senderEmail,
      'senderPhoneNumber': senderPhoneNumber,
      'senderDisplayName': senderDisplayName,
      'senderPhotoURL': senderPhotoURL,
      'ts': ts
    };
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatroomUID)
        .collection('messages')
        .add(data);
  }
}
