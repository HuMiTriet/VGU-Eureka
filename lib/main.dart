import 'package:etoet/constants/routes.dart';
import 'package:etoet/views/auth/login_view.dart';
import 'package:etoet/views/auth/recover_account_view.dart';
import 'package:etoet/views/auth/register_view.dart';
import 'package:etoet/views/auth/verified_email_view.dart';
import 'package:etoet/views/main_view.dart';
import 'package:etoet/views/settings_view.dart';
import 'package:etoet/views/sign_post.dart';
import 'package:flutter/material.dart';

import 'services/auth/auth_user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignPost(),

      //define the routes so that the app can navigate to the different views.
      onGenerateRoute: (settings) {
        final user = settings.arguments as AuthUser;
        switch (settings.name) {
          case mainRoute:
            return MaterialPageRoute(
              builder: (context) => MainView(user: user),
            );
          case loginRoute:
            return MaterialPageRoute(
              builder: (context) => const LoginView(),
            );
          case registerRoute:
            return MaterialPageRoute(
              builder: (context) => const RegisterView(),
            );
          case verifyEmailRoute:
            return MaterialPageRoute(
              builder: (context) => const VerifyEmailView(),
            );
          case recoverAccountRoute:
            return MaterialPageRoute(
              builder: (context) => const RecoverAccountView(),
            );
          case settingsRoute:
            return MaterialPageRoute(
              builder: (context) => const SettingsView(),
            );
          default:
            return null;
        }
      },
    ),
  );
}
