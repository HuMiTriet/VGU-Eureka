import 'package:flutter/material.dart';

@immutable
class UserInfo {
  final String uid;

  final String? email;
  final String? phoneNumber;
  final String? displayName;
  final String? photoURL;

  const UserInfo({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.displayName,
    this.photoURL,
  });
}
