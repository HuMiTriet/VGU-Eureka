import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../auth/auth_user.dart';
import '../auth/user_info.dart' as etoet;

class Firestore {
  static final firestoreReference = FirebaseFirestore.instance;

  Firestore._();

  late AuthUser user;

  static void addUserInfo(AuthUser user) {
    firestoreReference.collection('users').doc(user.uid).set(
      {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoURL ??
            'https://firebasestorage.googleapis.com/v0/b/etoet-pe2022.appspot.com/o/images%2FDefault.png?alt=media&token=9d2d4b15-cf04-44f1-b46d-ab0f06ab2977',
      },
    );
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
        .where('email', isLessThanOrEqualTo: emailQuery + '\uf8ff')
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

      if (alrFriend.docs.length == 0) {
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
        print(changes['friendUID']);
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
      friendRequestListener(String uid, BuildContext context) {
    var subscriber = firestoreReference
        .collection('users')
        .doc(uid)
        .collection('friends')
        //.where('isSender', isEqualTo: false)
        .snapshots(includeMetadataChanges: true)
        .listen((querySnapshot) {
      for (var change in querySnapshot.docChanges) {
        //final source = (querySnapshot.metadata.isFromCache) ? "local cache" : "server";
        var data = change.doc.data() as Map<String, dynamic>;
        //Check if change is from server
        if (querySnapshot.metadata.isFromCache == false)
        {
          if (change.type == DocumentChangeType.added)
          {
            if (data['isSender'] == false && data['requestConfirmed'] == false)
            {
              print('Received a friend request from UID:' + data['friendUID']);
            }
          }
          else if (change.type == DocumentChangeType.modified) {
            if (data['isSender'] == false && data['requestConfirmed'] == true)
            {
              print('You accepted a friend request from UID:' + data['friendUID']);
            }
            else if (data['isSender'] == true && data['requestConfirmed'] == true)
            {
              print('Your friend request was accepted by UID:' + data['friendUID']);
            }
          }
        }
      }
    });

    return subscriber;
  }

  static Stream<QuerySnapshot> getAcceptedFriendRequestStream(String uid) {
    var subscriber = firestoreReference
        .collection("users")
        .doc(uid)
        .collection('friends')
        .where("requestConfirmed", isEqualTo: true)
        .snapshots();

    return subscriber;
  }

  static Stream<QuerySnapshot> getPendingFriendStream(String userUID) {
    Stream<QuerySnapshot> _pendingFriendStream = Firestore.firestoreReference
        .collection('users')
        .doc(userUID)
        .collection('friends')
        .where('isSender', isEqualTo: false)
        .where('requestConfirmed', isEqualTo: false)
        .snapshots();
    return _pendingFriendStream;
  }
}
