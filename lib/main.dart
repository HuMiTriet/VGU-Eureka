import 'package:etoet/constants/routes.dart';
import 'package:etoet/views/auth/login_view.dart';
import 'package:etoet/views/auth/recover_account_view.dart';
import 'package:etoet/views/auth/register_view.dart';
import 'package:etoet/views/auth/verified_email_view.dart';
import 'package:etoet/views/profile/profile_page.dart';
import 'package:etoet/views/settings_view.dart';
import 'package:etoet/views/sign_post.dart';
import 'package:flutter/material.dart';

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
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        recoverAccountRoute: (context) => const RecoverAccountView(),
        settingsRoute: (context) => const SettingsView(),
        /* profileRoute: (context) =>  ProfilePage(), */
      },
    ),
  );
}
