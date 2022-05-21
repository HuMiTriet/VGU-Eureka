import 'package:flutter/material.dart';

import '../../services/auth/auth_user.dart';

abstract class VerificationView extends StatefulWidget {
  final AuthUser user;
  final String title;

  const VerificationView({
    Key? key,
    required this.user,
    required this.title,
  }) : super(key: key);
}
