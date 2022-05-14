import 'package:etoet/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test auth_user', () async {
    var user = await AuthService.firebase().createUser(
      email: 'triet403@gmail.com',
      password: 'triet403',
    );

    user.location.latitude = 10;
    user.location.longitude = 10;

    expect(user.location.longitude, 10);
  });
}
