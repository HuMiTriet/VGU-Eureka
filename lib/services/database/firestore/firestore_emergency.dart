import 'package:cloud_firestore/cloud_firestore.dart';
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
        'Lost and Found': lostAndFound,
        'Accident': accident,
        'Thieves': thief,
        'Other': other,
        'locationDescription': locationDescription,
        'situationDetail': situationDetail,
        'uid': uid,
      },
      SetOptions(merge: true),
    );
  }

  static void clearEmergency({required String uid}) {
    Firestore.firestoreReference.collection('emergencies').doc(uid).update(
      {
        'isPublic': false,
        'isFilled': false,
        'Lost and Found': false,
        'Accident': false,
        'Thieves': false,
        'Other': false,
        'locationDescription': '',
        'situationDetail': '',
      },
    );
  }
}
