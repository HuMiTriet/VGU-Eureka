import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/views/profile/verification_view.dart';
import 'package:flutter/material.dart';

class ChangePhoneNumberPage extends VerificationView {
  const ChangePhoneNumberPage({
    Key? key,
    required String title,
    required AuthUser user,
  }) : super(
          key: key,
          title: title,
          user: user,
        );

  @override
  _ChangePhoneNumberPageState createState() => _ChangePhoneNumberPageState();
}

class _ChangePhoneNumberPageState extends State<ChangePhoneNumberPage> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
