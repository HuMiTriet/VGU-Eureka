import 'package:etoet/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// FirebaseAuthProvider - AuthProvider - AuthService- UI
abstract class AuthProvider {
  Future<void> initialize();

  AuthUser? get currentUser;

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
    String? phoneNumber,
    String? displayName,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();

  Future<bool> validateEnteredPassword(String password);

  Future<void> verifyPhoneNumber(
      {required String phoneNumber,
      required void Function(PhoneAuthCredential) verificationCompleted,
      required void Function(FirebaseAuthException) verificationFailed,
      required void Function(String, int?) codeSent,
      required void Function(String) codeAutoRetrievalTimeout});
}
