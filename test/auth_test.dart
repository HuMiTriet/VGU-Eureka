import 'package:etoet/services/auth/concrete_providers/mock_auth_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// group inidividual unit tests into a test group
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not initialize at start', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Should be able to initialize', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null', () {
      expect(provider.currentUser, null);
    });

    /// Time sensitive test
    test(
      'Should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    /* test('created user should be logged in', () async { */
    /*   final badEmailUser = provider.createUser( */
    /*     email: 'foo@bar.com', */
    /*     password: 'ajdkasjdkasd', */
    /*   ); */

    /*   expect(badEmailUser, */
    /*       throwsA(const TypeMatcher<UserNotFoundAuthException>())); */
    /* }); */
  });
}
