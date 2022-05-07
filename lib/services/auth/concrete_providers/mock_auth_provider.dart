import 'package:etoet/services/auth/auth_exceptions.dart';
import 'package:etoet/services/auth/auth_provider.dart';
import 'package:etoet/services/auth/auth_user.dart';

class NotInitializedException implements Exception {}

/// Class to test if the backend produce the expected behaviors. DO NOT USE IN PRODUCTION
class MockAuthProvider implements AuthProvider {
  /// Firebase keep track if there is an instance of firebaseApp has been created
  /// initialize means that the the client side class FirebaseApp has been created
  /// and is ready to talk to the remote firebase database. Every method that
  /// works with the firebase backend requires that the firebaseApp is
  /// initialized.
  var _isIninitalized = false;

  AuthUser? _currentUser;

  bool get isInitialized => _isIninitalized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();

    await Future.delayed(const Duration(milliseconds: 500));

    return login(email: 'foo', password: 'bar');
  }

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isIninitalized = true;
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();

    if (_currentUser == null) throw UserNotFoundAuthException();

    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = null;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();

    const user = AuthUser(isEmailVerified: false);

    _currentUser = user;

    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();

    final user = _currentUser;

    if (user == null) throw UserNotFoundAuthException();

    const newUser = AuthUser(isEmailVerified: true);

    _currentUser = newUser;
  }
}
