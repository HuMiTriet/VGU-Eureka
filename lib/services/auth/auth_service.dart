import 'package:etoet/services/auth/auth_provider.dart';
import 'package:etoet/services/auth/auth_user.dart';

import 'firebase_auth_provider.dart';

/// Further abstract the backend from the UI layer.
///
/// Main task of the [AuthProvider] is the intreface that the UI layer use to
/// talk to the backend. This further level of abstraction is done so that the
// UI layer is decoupled from the backend..
class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
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
}
