import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final userDocument =
        await firestoreReference.collection('users').doc(uid).get();

    final data = userDocument.data() as Map<String, dynamic>;

    return etoet.UserInfo(
      uid: uid,
      email: data['email'],
      displayName: data['displayName'],
      photoURL: data['photoUrl'],
      phoneNumber: data['phoneNumber'],
    );
  }
}
