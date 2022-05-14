import 'package:etoet/services/auth/location.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

// This annotation immutable tells the compiler that the content of this class
// and its subclasses will not change.
@immutable
class AuthUser {
  //// provide current location of the user
  final Location location = Location(0, 0);

  final Set<String> friendUIDs = {};

  final String uid;
  final bool isEmailVerified;

  final String? phoneNumber;
  final String? email;
  final String? displayName;

  AuthUser({
    required this.isEmailVerified,
    required this.phoneNumber,
    required this.uid,
    this.email,
    this.displayName,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        uid: user.uid,
        isEmailVerified: user.emailVerified,
        phoneNumber: user.phoneNumber,
        email: user.email,
        displayName: user.displayName,
      );
}
