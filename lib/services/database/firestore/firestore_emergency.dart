import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/database/firestore/firestore.dart';
import 'package:etoet/services/map/geoflutterfire/geoflutterfire.dart';

class FirestoreEmergency extends Firestore {
  static void setEmergencySignal({
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
        'isPublic': isPublic,
        'locationDescription': locationDescription,
        'situationDetail': situationDetail,
        'uid': uid,
        'displayName': displayName,
        'phtoUrl': photoUrl,
        'position': GeoFlutterFire.getGeoFirePointData(
          latitude: lat,
          longitude: lng,
        ),
      },
      SetOptions(merge: true),
    );
  }

  static void acceptEmergencySignal({
    required String uid,
    required String email,
    required String phoneNumber,
    required String displayName,
    required String photoUrl,
  }) {
    /* Firestore.firestoreReference.collection('emergencies').doc(uid).get */

    Firestore.firestoreReference.collection('emergencies').doc(uid).update({
      'helperUID': uid,
      'helperEmail': email,
      'helperPhoneNumber': phoneNumber,
      'helperDisplayName': displayName,
      'helperPhotoUrl': photoUrl,
    });
  }
}
