import 'package:etoet/services/auth/auth_user.dart';

class DummyFriend
{
  AuthUser friend1 = AuthUser(email: 'friendEmail1@gmail.com', uid: 'fID01', isEmailVerified: true, displayName: 'Anya Forger');
  AuthUser friend2 = AuthUser(email: 'friendEmail2@gmail.com', uid: 'fID02', isEmailVerified: true, displayName: 'Loid Forger');
  AuthUser friend3 = AuthUser(email: 'friendEmail3@gmail.com', uid: 'fID03', isEmailVerified: true, displayName: 'Yor Forger');
  AuthUser friend4 = AuthUser(email: 'friendEmail4@gmail.com', uid: 'fID04', isEmailVerified: true, displayName: 'Chika');
  AuthUser friend5 = AuthUser(email: 'friendEmail5@gmail.com', uid: 'fID05', isEmailVerified: true, displayName: 'Aharen');

  Set<AuthUser> friendList =
  {};

  void testFunc()
  {
    friendList.add(friend1);
    friendList.add(friend2);
    friendList.add(friend3);
    friendList.add(friend4);
    friendList.add(friend5);

  }

}
