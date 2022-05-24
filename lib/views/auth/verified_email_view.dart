import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/database/firestore.dart';
import 'package:flutter/material.dart';

import '../../services/auth/auth_service.dart';
import '../../services/auth/auth_user.dart';

class VerifyEmailView extends StatefulWidget {
  final AuthUser user;

  const VerifyEmailView({Key? key, required this.user}) : super(key: key);

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    Firestore.addUserInfo(widget.user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifiy Email'),
      ),
      body: Column(
        children: [
          const Text('Please verify your email address: '),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('resend email verification'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Return to register screen'),
          )
        ],
      ),
    );
  }
}
