import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/auth/auth_user.dart';

import 'package:etoet/services/auth/user_info.dart' as etoet;

class Firestore {
  static final firestoreReference = FirebaseFirestore.instance;

  Firestore();

  static void addUserInfo(AuthUser user) {
    var userRef = firestoreReference.collection('users').doc(user.uid);
    userRef.set(
      {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoURL,
      },
    );

    /// attributes that are related to the fact that the user is helping someone else
    var userHelperRef = userRef.collection('helper').doc('helper');

    userHelperRef.set(
      {
        'helpRange': user.helpRange,
        'notificationsEnabled': user.notificationsEnabled,
        'isHelping': false,
      },
    );
  }

  static void updateUserInfo(AuthUser authUser) async {
    var userRef = firestoreReference.collection('users').doc(authUser.uid);
    userRef.update({
      'email': authUser.email,
      'displayName': authUser.displayName,
      'photoUrl': authUser.photoURL,
      'phoneNumber': authUser.phoneNumber,
    });
    var userHelperRef = userRef.collection('helper').doc('helper');

    userHelperRef.set(
      {
        'helpRange': authUser.helpRange,
        'notificationsEnabled': authUser.notificationsEnabled,
      },
    );
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
}
