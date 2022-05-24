import 'package:etoet/services/auth/location.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

// This annotation immutable tells the compiler that the content of this class
// and its subclasses will not change.
@immutable
class AuthUser extends etoet.UserInfo {
  //// provide current location of the user
  final Location location = Location();

  final Set<String> friendUIDs = {};

  final bool isEmailVerified;

  final Set<Tuple2<String, Location>> setFriendUIDLocation = {};

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
