import 'dart:developer' as devtools show log;

import 'package:etoet/constants/routes.dart';
import 'package:etoet/views/auth/error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
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
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );

                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();

                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (e) {
                devtools.log('$e', name: 'RegisterView');
                switch (e.code) {
                  case 'weak-password':
                    await showErrorDialog(context, 'Weak password');
                    break;

                  case 'email-already-in-use':
                    await showErrorDialog(context, 'Email already in use');
                    break;

                  case 'invalid-email':
                    await showErrorDialog(context, 'Invalid email');
                    break;

                  default:
                    await showErrorDialog(context, 'Error: ${e.code}');
                    break;
                }
              } catch (e) {
                await showErrorDialog(context, 'Error: ${e.toString()}');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
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
