import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/database/firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('add user info', () {
    var user = AuthUser(
      uid: '123',
      email: 'triet403@gmail.com',
      displayName: 'Triet',
      phoneNumber: '0989898989',
      isEmailVerified: true,
    );

    Firestore.addUserInfo(user);
  });
}
