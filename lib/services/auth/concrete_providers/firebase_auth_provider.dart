import 'dart:developer' as devtools show log;

import 'package:etoet/firebase_options.dart';
import 'package:etoet/services/auth/auth_exceptions.dart';
import 'package:etoet/services/auth/auth_provider.dart';
import 'package:etoet/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show
        EmailAuthProvider,
        FirebaseAuth,
        FirebaseAuthException,
        PhoneAuthCredential,
        UserCredential;
import 'package:firebase_auth_platform_interface/src/auth_credential.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthProvider implements AuthProvider {
  /* @override */
  /* Future<bool> validateEnteredPassword(String password) async { */
  /*   var firebaseUser = FirebaseAuth.instance.currentUser; */

  /*   if (firebaseUser == null) { */
  /*     /// User is not logged in */
  /*     return false; */
  /*   } else { */
  /*     var authCredential = EmailAuthProvider.credential( */
  /*       email: firebaseUser.email ?? '', */
  /*       password: password, */
  /*     ); */
  /*     try { */
  /*       var authResult = await firebaseUser.reauthenticateWithCredential( */
  /*         authCredential, */

  /*       return authResult.user != null; */
  /*       ); */
  /*     } catch (e) { */
  /*       devtools.log(e.toString()); */
  /*       return false; */
  /*     } */
  /*   } */

  /* } */

  @override
  Future<bool> validateEnteredPassword(String password) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;

    var authCredential = EmailAuthProvider.credential(
      email: firebaseUser?.email ?? '',
      password: password,
    );

    try {
      var authResult = await firebaseUser?.reauthenticateWithCredential(
        authCredential,
      );

      devtools.log(authResult.toString(), name: 'validate user password');

      if (authResult != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      devtools.log(e.toString(), name: 'validate user password');
      return false;
    }
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
    String? phoneNumber,
    String? displayName,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      /* final referenceUser = FirebaseAuth.instance.currentUser; */
      final firebaseUser = FirebaseAuth.instance.currentUser;

      /* FirebaseAuth.instance.userChanges().listen((firebaseUser) { */
      await firebaseUser?.updateDisplayName(displayName!);
      /* await firebaseUser?.updatePhoneNumber(phoneNumber); */
      /* }); */

      FirebaseAuth.instance.currentUser!.reload();

      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw WeakPassowrdAuthException();

        case 'email-already-in-use':
          throw EmailAlreadyInUsedAuthException();

        case 'invalid-email':
          throw InvalidEmailAuthException();

        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser(
        isEmailVerified: user.emailVerified,
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        phoneNumber: user.phoneNumber,
      );
    } else {
      return null;
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          throw WrongPasswordAuthException();
        case 'user-not-found':
          throw UserNotFoundAuthException();

        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      // you can not send verification email if you are not logged in.
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> verifyPhoneNumber(
      {required String phoneNumber,
      required void Function(PhoneAuthCredential) verificationCompleted,
      required void Function(FirebaseAuthException) verificationFailed,
      required void Function(String, int?) codeSent,
      required void Function(String) codeAutoRetrievalTimeout}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  @override
  Future<UserCredential> linkWithCredential(
      {required AuthCredential credential}) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.linkWithCredential(credential);
    } else {
      //triggered when user not logged in
      throw UserNotLoggedInAuthException();
    }
  }

  Future<void> updatePhotoURL(String url) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.updatePhotoURL(url);
    } else {
      // you can not send verification email if you are not logged in.
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> updateDisplayName(String name) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.updateDisplayName(name);
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}
