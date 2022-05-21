import 'package:etoet/services/auth/auth_provider.dart';
import 'package:etoet/services/auth/auth_user.dart';

import 'concrete_providers/firebase_auth_provider.dart';

/// Using the Factory method design pattern to abstract the backend from UI.
///
/// FirebaseAuthProvider - AuthProvider - AuthService- UI
///
/// This class for now does not do anything for now but it is used for ease of
/// database expansion in the future. You can use the AuthProvider class directly
// but this is not advised.
class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
    String? phoneNumber,
    String? displayName,
  }) =>
      provider.createUser(
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        displayName: displayName,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(
        email: email,
        password: password,
      );

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<bool> validateEnteredPassword(String password) async =>
      provider.validateEnteredPassword(password);
}
