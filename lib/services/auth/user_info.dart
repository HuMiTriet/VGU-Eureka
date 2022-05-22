class UserInfo {
  final String uid;

  final String? email;
  final String? phoneNumber;
  final String? displayName;
  final String? photoURL;

  UserInfo({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.displayName,
    this.photoURL,
  });
}
