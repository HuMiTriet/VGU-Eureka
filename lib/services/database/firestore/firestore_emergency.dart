import 'dart:developer' as devtools show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/auth/emergency.dart';
import 'package:etoet/services/database/firestore/firestore.dart';
import 'package:etoet/services/map/geoflutterfire/geoflutterfire.dart';

class FirestoreEmergency extends Firestore {
  static void setEmergencySignal({
    required String helpStatus,
    required String emergencyType,
    required String uid,
    required String displayName,
    required String photoUrl,
    required String locationDescription,
    required String situationDetail,
    required double lat,
    required double lng,
    required bool isPublic,
  }) {
    Firestore.firestoreReference.collection('emergencies').doc(uid).set(
      {
        'helpStatus': helpStatus,
        'isPublic': isPublic,
        'emergencyType': emergencyType,
        'locationDescription': locationDescription,
        'situationDetail': situationDetail,
        'uid': uid,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'position': GeoFlutterFire.getGeoFirePointData(
          latitude: lat,
          longitude: lng,
        ),
      },
      SetOptions(merge: true),
    );
    devtools.log('Emergency signal set: $uid', name: 'FirestoreEmergency');
  }

  /// used by the helpee (the person needing help)
  static void clearEmergency({required String uid}) {
    Firestore.firestoreReference.collection('emergencies').doc(uid).delete();

    devtools.log('Emergency signal clear: $uid', name: 'FirestoreEmergency');
  }

  static Future<Emergency> getEmergencySignal({required String uid}) async {
    // ignore: prefer_typing_uninitialized_variables
    var emergency = Emergency();
    await Firestore.firestoreReference
        .collection('emergencies')
        .doc(uid)
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

  static Future<bool> signalExists({required String uid}) async {
    final signalDocument = await Firestore.firestoreReference
        .collection('emergencies')
        .where('uid', isEqualTo: uid)
        .get(const GetOptions(source: Source.serverAndCache));

    return signalDocument.docs.isNotEmpty;
  }

  static void acceptEmergencySignal({
    required String helpStatus,
    required String helpeeUID,
    required String uid,
    required String email,
    required String phoneNumber,
    required String displayName,
    required String photoUrl,
  }) {
    Firestore.firestoreReference
        .collection('emergencies')
        .doc(helpeeUID)
        .update({
      'helpStatus': helpStatus,
      'helperUID': uid,
      'helperEmail': email,
      'helperPhoneNumber': phoneNumber,
      'helperDisplayName': displayName,
      'helperPhotoUrl': photoUrl,
    });
  }

  static void abortEmergencySignal({
    required String helpeeUID,
  }) {
    Firestore.firestoreReference
        .collection('emergencies')
        .doc(helpeeUID)
        .update({
      'helpStatus': 'helperAbort',
      'helperUID': FieldValue.delete(),
      'helperEmail': FieldValue.delete(),
      'helperPhoneNumber': FieldValue.delete(),
      'helperDisplayName': FieldValue.delete(),
      'helperPhotoUrl': FieldValue.delete(),
    });
  }

  static void doneEmergencySignal({
    required String helpeeUID,
  }) {
    Firestore.firestoreReference
        .collection('emergencies')
        .doc(helpeeUID)
        .update({
      'helpStatus': 'helperDone',
      'helperUID': FieldValue.delete(),
      'helperEmail': FieldValue.delete(),
      'helperPhoneNumber': FieldValue.delete(),
      'helperDisplayName': FieldValue.delete(),
      'helperPhotoUrl': FieldValue.delete(),
    });
  }
}
