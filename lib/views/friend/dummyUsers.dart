import 'package:etoet/services/auth/auth_user.dart';

class DummyUser{
  AuthUser user1 = AuthUser(isEmailVerified: true, uid: 'id001', email: 'testEmail01@gmail.com', displayName:'Anya Forger');
  AuthUser user2 = AuthUser(isEmailVerified: true, uid: 'id002', email: 'testEmail02@gmail.com', displayName:'Loid Forger');
  AuthUser user3 = AuthUser(isEmailVerified: true, uid: 'id003', email: 'testEmail03@gmail.com', displayName:'Yor Forger');
  AuthUser user4 = AuthUser(isEmailVerified: true, uid: 'id004', email: 'testEmail04@gmail.com', displayName:'Kohaku Nene');
  AuthUser user5 = AuthUser(isEmailVerified: true, uid: 'id005', email: 'testEmail05@gmail.com', displayName:'Aharen');


  AuthUser user6 = AuthUser(isEmailVerified: true, uid: 'id006', email: 'testEmail06@gmail.com', displayName:'Justyna Valentine');
  AuthUser user7 = AuthUser(isEmailVerified: true, uid: 'id007', email: 'testEmail07@gmail.com', displayName:'Chris Redfield');

  late List<AuthUser> userList;
  late List<AuthUser> addAsFriendUserList;

  DummyUser()
  {
    userList = [user1]; // Needs to Initialize?
    userList.add(user2);
    userList.add(user3);
    userList.add(user4);
    userList.add(user5);

    addAsFriendUserList = [user6];
    addAsFriendUserList.add(user7);
  }

  // void init()
}