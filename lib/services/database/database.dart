import 'package:etoet/services/auth/auth_user.dart';
import 'package:firebase_database/firebase_database.dart';

/// know which database to connect to
final databaseReference = FirebaseDatabase.instance.ref();

void updateUserLocation(AuthUser authUser) {
  var location = databaseReference
      .child('users/')
      .child(authUser.uid)
      .child('location')
      .push();

  location.set(authUser.location.toJson());
}
