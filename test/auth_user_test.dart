import 'package:etoet/services/auth/auth_service.dart';
import 'package:etoet/services/auth/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test auth_user', () async {
    var user = AuthUser(
      uid: '123',
      email: 'triet403@gmail.com',
      displayName: 'Triet',
      phoneNumber: '0989898989',
      isEmailVerified: true,
    );

    user.location.latitude = 10;
    user.location.longitude = 10;

    expect(user.location.longitude, 10);
  });
}
