import 'package:etoet/services/auth/auth_user.dart';

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
}
