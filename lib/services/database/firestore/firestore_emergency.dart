import 'dart:developer' as devtools show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/auth/emergency.dart';
import 'package:etoet/services/database/firestore/firestore.dart';

//Emergency class for emergency functions only
class FirestoreEmergency extends Firestore {
  //Constructor
  FirestoreEmergency() : super();

  static void setEmergencySignal({
    required String uid,
    required bool lostAndFound,
    required bool accident,
    required bool thief,
    required bool other,
    required bool isPublic,
    required bool isFilled,
    required String locationDescription,
    required String situationDetail,
  }) {
    Firestore.firestoreReference.collection('emergencies').doc(uid).set(
      {
        'isPublic': isPublic,
        'isFilled': isFilled,
        'lostAndFound': lostAndFound,
        'accident': accident,
        'thief': thief,
        'other': other,
        'locationDescription': locationDescription,
        'situationDetail': situationDetail,
        'uid': uid,
      },
      SetOptions(merge: true),
    );
    devtools.log('Emergency signal set: $uid', name: 'FirestoreEmergency');
  }

  static void clearEmergency({required String uid}) {
    Firestore.firestoreReference.collection('emergencies').doc(uid).update(
      {
        'isPublic': false,
        'isFilled': false,
        'lostAndFound': false,
        'accident': false,
        'thief': false,
        'other': false,
        'locationDescription': '',
        'situationDetail': '',
      },
    );

    Firestore.firestoreReference
        .collection('users')
        .doc(uid)
        .collection('emergency')
        .doc('emergency')
        .update(
      {
        'isPublic': false,
        'isFilled': false,
        'lostAndFound': false,
        'accident': false,
        'thief': false,
        'other': false,
        'locationDescription': '',
        'situationDetail': '',
      },
    );

    devtools.log('Emergency signal clear: $uid', name: 'FirestoreEmergency');
  }

  static Future<Emergency> getEmergencySignal({required String uid}) async {
    // ignore: prefer_typing_uninitialized_variables
    var emergency = Emergency();
    await Firestore.firestoreReference
        .collection('users')
        .doc(uid)
        .collection('emergency')
        .doc('emergency')
        .get()
        .then(
      (snapshot) {
        if (snapshot.exists) {
          devtools.log('Emergency signal get: $uid',
              name: 'FirestoreEmergency');
          emergency = Emergency.fromJson(snapshot.data()!);
        } else {
          devtools.log('Emergency signal get: $uid not found',
              name: 'FirestoreEmergency');
        }
      },
    );
    return emergency;
  }
}
