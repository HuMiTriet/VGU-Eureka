import 'package:etoet/services/auth/emergency.dart';
import 'package:etoet/services/auth/location.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:firebase_auth/firebase_auth.dart';

// This annotation immutable tells the compiler that the content of this class
// and its subclasses will not change.
class AuthUser extends etoet.UserInfo {
  //// provide current location of the user
  final Location location = Location();

  late Emergency emergency = Emergency();

  final bool isEmailVerified;

  final Map<String, Location> mapFriendUidLocation = {};

  final Set<etoet.UserInfo> friendInfoList = {};

  final Set<etoet.UserInfo> pendingFriendInfoList = {};

  int helpRange = 5;

  bool notificationsEnabled = true;


  AuthUser({
    required this.isEmailVerified,
    required super.uid,
    this.helpRange = 5,
    this.notificationsEnabled = true,
    super.email,
    super.phoneNumber,
    super.displayName,
    super.photoURL =
        'https://firebasestorage.googleapis.com/v0/b/etoet-pe2022.appspot.com/o/images%2FDefault.png?alt=media&token=9d2d4b15-cf04-44f1-b46d-ab0f06ab2977',
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
        emergency: ${emergency.toString()},
      }
    ''';
  }

  factory AuthUser.fromFirebase(User? user) => AuthUser(
        uid: user!.uid,
        isEmailVerified: user.emailVerified,
        phoneNumber: user.phoneNumber,
        email: user.email,
        displayName: user.displayName,
        photoURL: user.photoURL,
      );
}
