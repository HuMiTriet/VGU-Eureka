import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/database/firestore.dart';
import 'package:flutter/material.dart';
import '../auth/user_info.dart' as etoet;

class FirestoreFriend extends Firestore {
  //Constructor
  FirestoreFriend() : super();

  //Function name is abit misleading, only used for finding friends using email
  static Future<Set<etoet.UserInfo>> getUserInfoFromEmail(
      String emailQuery, String userUID) async {
    //
    emailQuery = emailQuery.toLowerCase();

    var res = await Firestore.firestoreReference
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: emailQuery)
        .where('email', isLessThanOrEqualTo: '$emailQuery\uf8ff')
        // .where('uid', )
        .get();

    var alrFriend = await Firestore.firestoreReference
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

    Firestore.firestoreReference
        .collection('users')
        .doc(senderUID)
        .collection('friends')
        .doc(receiverUID)
        .set(senderData);
    Firestore.firestoreReference
        .collection('users')
        .doc(receiverUID)
        .collection('friends')
        .doc(senderUID)
        .set(receiverData);
  }

  static Future<Set<etoet.UserInfo>> getPendingRequestUserInfo(
      String userUID) async {
    var pendingFriendRequestData = await Firestore.firestoreReference
        .collection('users')
        .doc(userUID)
        .collection('friends')
        .where('isSender', isEqualTo: false)
        .where('requestConfirmed', isEqualTo: false)
        .get();

    var pendingFriendInfoList = <etoet.UserInfo>{};
    for (var i = 0; i < pendingFriendRequestData.docs.length; ++i) {
      var source =
          pendingFriendRequestData.metadata.isFromCache ? 'cache' : 'server';
      print('Pending fetched from $source');
      var data = pendingFriendRequestData.docs.elementAt(i).data();

      var pendingFriendInfo = await Firestore.getUserInfo(data['friendUID']);
      pendingFriendInfoList.add(pendingFriendInfo);
    }

    return pendingFriendInfoList;
  }

  static Future<Set<etoet.UserInfo>> getAcceptedUserInfo(String userUID) async {
    var pendingFriendRequestData = await Firestore.firestoreReference
        .collection('users')
        .doc(userUID)
        .collection('friends')
        .where('requestConfirmed', isEqualTo: false)
        .get();

    var pendingFriendInfoList = <etoet.UserInfo>{};
    for (var i = 0; i < pendingFriendRequestData.docs.length; ++i) {
      var source =
          pendingFriendRequestData.metadata.isFromCache ? 'cache' : 'server';
      print('Pending fetched from $source');
      var data = pendingFriendRequestData.docs.elementAt(i).data();

      var pendingFriendInfo = await Firestore.getUserInfo(data['friendUID']);
      pendingFriendInfoList.add(pendingFriendInfo);
    }

    return pendingFriendInfoList;
  }

  static void deleteFriendRequest(String receiverUID, String senderUID) {
    Firestore.firestoreReference
        .collection('users')
        .doc(receiverUID)
        .collection('friends')
        .doc(senderUID)
        .delete();
    Firestore.firestoreReference
        .collection('users')
        .doc(senderUID)
        .collection('friends')
        .doc(receiverUID)
        .delete();
  }

  static void acceptFriendRequest(String receiverUID, String senderUID) {
    Firestore.firestoreReference
        .collection('users')
        .doc(receiverUID)
        .collection('friends')
        .doc(senderUID)
        .update({'requestConfirmed': true});
    Firestore.firestoreReference
        .collection('users')
        .doc(senderUID)
        .collection('friends')
        .doc(receiverUID)
        .update({'requestConfirmed': true});
  }

  static Future<Set<etoet.UserInfo>> getFriendInfoList(String uid) async {
    var friendData = await Firestore.firestoreReference
        .collection('users')
        .doc(uid)
        .collection('friends')
        .where('requestConfirmed', isEqualTo: true)
        .get();

    var friendInfoList = <etoet.UserInfo>{};
    for (var i = 0; i < friendData.docs.length; ++i) {
      var data = friendData.docs.elementAt(i).data();
      friendInfoList.add(await Firestore.getUserInfo(data['friendUID']));
    }

    return friendInfoList;
  }

  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      pendingFriendRequestReceiverListener(String uid, BuildContext context) {
    var subscriber = Firestore.firestoreReference
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
    var subscriber = Firestore.firestoreReference
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
}
