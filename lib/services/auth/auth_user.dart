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

  AuthUser({
    required this.isEmailVerified,
    required this.uid,
    required this.email,
    this.phoneNumber,
    this.displayName,
  });

    
  @override
    String toString() {
    return '''
      AuthUser {
        uid: $uid,
        isEmailVerified: $isEmailVerified,
        phoneNumber: $phoneNumber,
        email: $email,
        displayName: $displayName,
      }
    ''';
    }
}
