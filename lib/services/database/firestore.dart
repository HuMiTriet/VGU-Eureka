import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../auth/auth_user.dart';
import '../auth/user_info.dart' as etoet;

class Firestore {
  static final firestoreReference = FirebaseFirestore.instance;

  Firestore();

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
    required String message,
    bool isPublic = false,
  }) {
    firestoreReference.collection('emergencies').doc(uid).set(
      {
        'isPublic': isPublic,
        'message': message,
        'uid': uid,
      },
      SetOptions(merge: true),
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
