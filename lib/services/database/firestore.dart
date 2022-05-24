import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

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

  static Future<Set<etoet.UserInfo>> getUserInfoFromEmail(String emailQuery) async {

    //
    emailQuery = emailQuery.toLowerCase();

    var res = await firestoreReference.collection('users')
        .where('email', isGreaterThanOrEqualTo: emailQuery)
        .where('email', isLessThanOrEqualTo: emailQuery + '\uf8ff')
        .get();

    var searchedUserInfoList = <etoet.UserInfo>{};

    for(var i = 0; i < res.docs.length; ++i)
      {
        var data = res.docs.elementAt(i).data();
        var userInfo = etoet.UserInfo(
          uid: data['uid'],
          displayName: data['displayName'],
          email: data['email'],
          photoURL: data['photoUrl'],
        );

        searchedUserInfoList.add(userInfo);
      }

    //devtools.log('$res', name: 'Firestore: getUserInfoFromDisplayName');

    return searchedUserInfoList;
  }

}
