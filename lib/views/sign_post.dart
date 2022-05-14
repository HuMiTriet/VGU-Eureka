import 'dart:developer' as devtools show log;

import 'package:etoet/main.dart';
import 'package:etoet/services/auth/auth_service.dart';
import 'package:etoet/views/auth/login_view.dart';
import 'package:etoet/views/auth/verified_email_view.dart';
import 'package:etoet/views/main_view.dart';
import 'package:flutter/material.dart';

///this class direct the app to the correct view based on the authentication
///status of the current user
class SignPost extends StatelessWidget {
  const SignPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;

            devtools.log(user.toString());

            if (user != null) {
              if (user.isEmailVerified) {
                var mainView = MainView();
                mainView.authUser = user;

                /// user is logged in and email is verified
                return mainView;
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
