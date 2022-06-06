class UserInfo {
  final String uid;

  String? email;
  String? phoneNumber;
  String? displayName;
  String photoURL;

  UserInfo({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.displayName,
    this.photoURL =
        'https://firebasestorage.googleapis.com/v0/b/etoet-pe2022.appspot.com/o/images%2FDefault.png?alt=media&token=9d2d4b15-cf04-44f1-b46d-ab0f06ab2977',
  });
}
