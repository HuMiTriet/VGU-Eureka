import 'package:etoet/services/auth/location.dart';
import 'package:flutter/foundation.dart';

// This annotation immutable tells the compiler that the content of this class
// and its subclasses will not change.
@immutable
class AuthUser {
  //// provide current location of the user
  final Location location = Location();

  final Set<String> friendUIDs = {};

  final String uid;
  final bool isEmailVerified;

  final String? phoneNumber;
  final String? email;
  final String? displayName;
  final String? photoURL;

  AuthUser(
      {required this.isEmailVerified,
      required this.phoneNumber,
      required this.uid,
      this.email,
      this.displayName,
      this.photoURL});

  factory AuthUser.fromFirebase(User user) => AuthUser(
      uid: user.uid,
      isEmailVerified: user.emailVerified,
      phoneNumber: user.phoneNumber,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL);
}
