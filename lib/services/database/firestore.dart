import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/map/geoflutterfire/geoflutterfire.dart';
import 'package:flutter/material.dart';

import '../auth/auth_user.dart';
import '../auth/user_info.dart' as etoet;

class Firestore {
  static final firestoreReference = FirebaseFirestore.instance;

  Firestore._();

  static void addUserInfo(AuthUser user) {
    firestoreReference.collection('users').doc(user.uid).set(
      {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoURL,
      },
    );
  }

  static void updateUserInfo(AuthUser authUser) async {
    firestoreReference.collection('users').doc(authUser.uid).update({
      'email': authUser.email,
      'displayName': authUser.displayName,
      'photoUrl': authUser.photoURL,
      'phoneNumber': authUser.phoneNumber,
    });
  }

  static void setFcmTokenAndNotificationStatus(
      {required String uid, required String token}) {
    firestoreReference
        .collection('users')
        .doc(uid)
        .collection('notification')
        .doc('fcm_token')
        .set(
      {
        'enable_notification': true,
        'fcm_token': token,
      },
    );
  }

  static void setEmergencySignal({
    required String uid,
    // required String type,
    required String locationDescription,
    required String situationDetail,
    bool isPublic = false,
  }) {
    firestoreReference.collection('emergencies').doc(uid).set(
      {
        'isPublic': isPublic,
        // 'type': type,
        'locationDescription': locationDescription,
        'situationDetail': situationDetail,
        'uid': uid,
      },
      SetOptions(merge: true),
    );
  }

  static void updateEmergencySignalLocation(
      {required String uid, required double lat, required double lng}) async {
    GeoFlutterFire.updateEmergencySignalLocation(uid: uid, lat: lat, lng: lng);
  }

  static Future<etoet.UserInfo> getUserInfo(String uid) async {
    const source = Source.serverAndCache;
    final userDocument = await firestoreReference
        .collection('users')
        .doc(uid)
        .get(const GetOptions(source: source));

    final data = userDocument.data() as Map<String, dynamic>;

    return etoet.UserInfo(
      uid: uid,
      email: data['email'],
      displayName: data['displayName'],
      photoURL: data['photoUrl'],
      phoneNumber: data['phoneNumber'],
    );
  }

  static Future<bool> userExists(String uid) async {
    final userDocument = await firestoreReference
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get(const GetOptions(source: Source.serverAndCache));

    return userDocument.docs.isNotEmpty;
  }

  //Function name is abit misleading, only used for finding friends using email
  static Future<Set<etoet.UserInfo>> getUserInfoFromEmail(
      String emailQuery, String userUID) async {
    //
    emailQuery = emailQuery.toLowerCase();

    var res = await firestoreReference
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: emailQuery)
        .where('email', isLessThanOrEqualTo: '$emailQuery\uf8ff')
        // .where('uid', )
        .get();

    var alrFriend = await firestoreReference
        .collection('users')
        .doc(userUID)
        .collection('friends')
        .where('requestConfirmed', isEqualTo: true)
        .get();

    var searchedUserInfoList = <etoet.UserInfo>{};

    for (var i = 0; i < res.docs.length; ++i) {
      var data = res.docs.elementAt(i).data();
      var userInfo = etoet.UserInfo(
        uid: data['uid'],
        displayName: data['displayName'],
        email: data['email'],
        photoURL: data['photoUrl'],
      );
      if (userInfo.uid == userUID) {
        continue;
      }

      if (alrFriend.docs.isEmpty) {
        searchedUserInfoList.add(userInfo);
        continue;
      }

      for (var j = 0; j < alrFriend.docs.length; ++j) {
        var alrFriendData = alrFriend.docs.elementAt(j).data();
        if (userInfo.uid == alrFriendData['friendUID']) {
          break;
        } else if (j == (alrFriend.docs.length - 1)) {
          searchedUserInfoList.add(userInfo);
        }
      }
    }

    //devtools.log('$res', name: 'Firestore: getUserInfoFromDisplayName');

    return searchedUserInfoList;
  }

  static void sendFriendRequest(String senderUID, String receiverUID) {
    var senderData = {
      'isSender': true,
      'requestConfirmed': false,
      'friendUID': receiverUID
    };

    var receiverData = {
      'isSender': false,
      'requestConfirmed': false,
      'friendUID': senderUID
    };

    firestoreReference
        .collection('users')
        .doc(senderUID)
        .collection('friends')
        .doc(receiverUID)
        .set(senderData);
    firestoreReference
        .collection('users')
        .doc(receiverUID)
        .collection('friends')
        .doc(senderUID)
        .set(receiverData);
  }

  static Future<Set<etoet.UserInfo>> getPendingRequestUserInfo(
      String userUID) async {
    var pendingFriendRequestData = await firestoreReference
        .collection('users')
        .doc(userUID)
        .collection('friends')
        .where('isSender', isEqualTo: false)
        .where('requestConfirmed', isEqualTo: false)
        .get();

    var pendingFriendInfoList = <etoet.UserInfo>{};
    for (var i = 0; i < pendingFriendRequestData.docs.length; ++i) {
      var source =
          pendingFriendRequestData.metadata.isFromCache ? "cache" : "server";
      print('Pending fetched from ' + source);
      var data = pendingFriendRequestData.docs.elementAt(i).data();

      var pendingFriendInfo = await getUserInfo(data['friendUID']);
      pendingFriendInfoList.add(pendingFriendInfo);
    }

    return pendingFriendInfoList;
  }

  static Future<Set<etoet.UserInfo>> getAcceptedUserInfo(String userUID) async {
    var pendingFriendRequestData = await firestoreReference
        .collection('users')
        .doc(userUID)
        .collection('friends')
        .where('requestConfirmed', isEqualTo: false)
        .get();

    var pendingFriendInfoList = <etoet.UserInfo>{};
    for (var i = 0; i < pendingFriendRequestData.docs.length; ++i) {
      var source =
          pendingFriendRequestData.metadata.isFromCache ? "cache" : "server";
      print('Pending fetched from ' + source);
      var data = pendingFriendRequestData.docs.elementAt(i).data();

      var pendingFriendInfo = await getUserInfo(data['friendUID']);
      pendingFriendInfoList.add(pendingFriendInfo);
    }

    return pendingFriendInfoList;
  }

  static void deleteFriendRequest(String receiverUID, String senderUID) {
    firestoreReference
        .collection('users')
        .doc(receiverUID)
        .collection('friends')
        .doc(senderUID)
        .delete();
    firestoreReference
        .collection('users')
        .doc(senderUID)
        .collection('friends')
        .doc(receiverUID)
        .delete();
  }

  static void acceptFriendRequest(String receiverUID, String senderUID) {
    firestoreReference
        .collection('users')
        .doc(receiverUID)
        .collection('friends')
        .doc(senderUID)
        .update({'requestConfirmed': true});
    firestoreReference
        .collection('users')
        .doc(senderUID)
        .collection('friends')
        .doc(receiverUID)
        .update({'requestConfirmed': true});
    firestoreReference.collection('friendship').doc(senderUID).set(
      {
        'receiverUID': receiverUID,
      },
    );
  }

  static Future<Set<etoet.UserInfo>> getFriendInfoList(String uid) async {
    var friendData = await firestoreReference
        .collection('users')
        .doc(uid)
        .collection('friends')
        .where('requestConfirmed', isEqualTo: true)
        .get();

    var friendInfoList = <etoet.UserInfo>{};
    for (var i = 0; i < friendData.docs.length; ++i) {
      var data = friendData.docs.elementAt(i).data();
      friendInfoList.add(await getUserInfo(data['friendUID']));
    }

    return friendInfoList;
  }

  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      pendingFriendRequestReceiverListener(String uid, BuildContext context) {
    var subscriber = firestoreReference
        .collection('users')
        .doc(uid)
        .collection('friends')
        .where('isSender', isEqualTo: false)
        .where('requestConfirmed', isEqualTo: false)
        .snapshots()
        .listen((querySnapshot) {
      for (var i = 0; i < querySnapshot.docChanges.length; ++i) {
        var changes = querySnapshot.docChanges.elementAt(i).doc.data()!;
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                    'Received a friend request from:' + changes['friendUID']),
              );
            });
      }
    });

    return subscriber;
  }

  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      pendingFriendRequestSenderListener(String uid, BuildContext context) {
    var subscriber = firestoreReference
        .collection('users')
        .doc(uid)
        .collection('friends')
        .where('isSender', isEqualTo: true)
        .where('requestConfirmed', isEqualTo: false)
        .snapshots()
        .listen((querySnapshot) {
      for (var i = 0; i < querySnapshot.docChanges.length; ++i) {
        var changes = querySnapshot.docChanges.elementAt(i).doc.data()!;
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Friend request sent to' + changes['friendUID']),
              );
            });
      }
    });

    return subscriber;
  }

  static Stream<QuerySnapshot> getPendingFriendStream(String userUID) {
    Stream<QuerySnapshot> pendingFriendStream = Firestore.firestoreReference
        .collection('users')
        .doc(userUID)
        .collection('friends')
        .where('isSender', isEqualTo: false)
        .where('requestConfirmed', isEqualTo: false)
        .snapshots();
    return pendingFriendStream;
  }

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


    if(data1.data()!['chatroomUID'] == null || data2.data()!['chatroomUID'] == null)
    {
      user1Ref.set(
          {
            'chatroomUID': chatroomUID
          },
          SetOptions(merge: true)
      );
      user2Ref.set(
          {
            'chatroomUID': chatroomUID
          },
          SetOptions(merge: true)
      );
      Firestore.firestoreReference
          .collection('chatrooms')
          .doc(chatroomUID)
          .set({'user1UID': userUID1, 'user2UID': userUID2});
    }

  }

  static Future<String> getChatroomUID(String user1UID, String user2UID)
  async {
    var ref = await firestoreReference.
    collection('users').
    doc(user1UID).
    collection('friends').
    doc(user2UID).
    get();

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
