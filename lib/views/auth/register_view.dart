import 'dart:developer' as devtools show log;

import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/auth_exceptions.dart';
import 'package:etoet/services/auth/auth_service.dart';
import 'package:etoet/views/auth/error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:etoet/views/auth/verified_email_view.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 210, 177, 2),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text(
                'Create Account ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 100),

              /// user name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _username,
                    enableSuggestions: false,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: ' Username',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '  Email',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              // password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '  Password',
                    ),
                  ),
                ),
              ),
              // Register button
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints.tightForFinite(
                    width: 250,
                    height: 40,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(227, 252, 126, 0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
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

                        AuthService.firebase().sendEmailVerification();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyEmailView(user: user),
                          ),
                        );
                      } on WeakPassowrdAuthException {
                        await showErrorDialog(context, 'Weak password');
                      } on EmailAlreadyInUsedAuthException {
                        await showErrorDialog(context, 'Email already in use');
                      } on InvalidEmailAuthException {
                        await showErrorDialog(context, 'Invalid email');
                      } on GenericAuthException {
                        await showErrorDialog(context, 'Unknown error');
                      }
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              // Already registered ? Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _username = TextEditingController();
    super.initState();
  }
}
