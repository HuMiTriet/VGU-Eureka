import 'package:etoet/views/profile/verification_view.dart';
import 'package:flutter/material.dart';

import '../../services/auth/auth_user.dart';

class ChangeEmailPage extends VerificationView {
  const ChangeEmailPage({
    Key? key,
    required String title,
    required AuthUser user,
  }) : super(
          key: key,
          title: title,
          user: user,
        );
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
