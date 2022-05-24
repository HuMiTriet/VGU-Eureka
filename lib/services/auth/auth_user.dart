import 'package:etoet/services/auth/location.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:firebase_auth/firebase_auth.dart';
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

  final Set<UserInfo> friendInfoList = {};


  AuthUser({
    required this.isEmailVerified,
    required super.uid,
    super.email,
    super.phoneNumber,
    super.displayName,
    super.photoURL = 'https://firebasestorage.googleapis.com/v0/b/etoet-pe2022.appspot.com/o/images%2FDefault.png?alt=media&token=9d2d4b15-cf04-44f1-b46d-ab0f06ab2977',
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

  factory AuthUser.fromFirebase(User? user) => AuthUser(
      uid: user!.uid,
      isEmailVerified: user.emailVerified,
      phoneNumber: user.phoneNumber,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL);
}
