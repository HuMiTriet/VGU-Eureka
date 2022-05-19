import 'dart:developer' as devtools show log;

import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/auth_exceptions.dart';
import 'package:etoet/services/auth/auth_service.dart';
import 'package:etoet/views/auth/error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  /// Group of controllers that handle each of the text field
  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _phoneNumber;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _username.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _username = TextEditingController();
    _phoneNumber = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          /// user name
          TextField(
            controller: _username,
            enableSuggestions: false,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),

          /// email
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
          ),

          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),

          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              final username = _username.text;

              try {
                var user = await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                  displayName: username,
                );

                devtools.log('After User created: ');

                devtools.log(user.toString());

                AuthService.firebase().sendEmailVerification();

                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPassowrdAuthException {
                await showErrorDialog(context, 'Weak password');
              } on EmailAlreadyInUsedAuthException {
                await showErrorDialog(context, 'Email already in use');
              } on InvalidEmailAuthException {
                await showErrorDialog(context, 'Invalid email');
              } on FirebaseAuthException catch (e) {
              devtools.log(e.toString());
                await showErrorDialog(context, 'Unknown error');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () async {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('already registerd ? Login')),
        ],
      ),
    );
  }
}
