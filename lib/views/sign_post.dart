import 'dart:developer' as devtools show log;

import 'package:etoet/firebase_options.dart';
import 'package:etoet/views/auth/login_view.dart';
import 'package:etoet/views/auth/verified_email_view.dart';
import 'package:etoet/views/main_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

///this class direct the app to the correct view based on the authentication
///status of the current user
class SignPost extends StatelessWidget {
  const SignPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;

            devtools.log(user.toString());

            if (user != null) {
              if (user.emailVerified) {
                /// user is logged in and email is verified
                return const MainView();
              } else {
                /// user is logged in but email is not verified
                return const VerifyEmailView();
              }
            } else {
              /// user is not logged in
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
