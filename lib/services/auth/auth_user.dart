import 'package:etoet/services/auth/location.dart';
import 'package:etoet/services/auth/user_info.dart';
import 'package:flutter/foundation.dart';

// This annotation immutable tells the compiler that the content of this class
// and its subclasses will not change.
@immutable
class AuthUser extends UserInfo {
  //// provide current location of the user
  final Location location = Location();

  final Set<String> friendUIDs = {};

  final bool isEmailVerified;

  AuthUser({
    required this.isEmailVerified,
    required super.uid,
    super.email,
    super.phoneNumber,
    super.displayName,
    super.photoURL,
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
