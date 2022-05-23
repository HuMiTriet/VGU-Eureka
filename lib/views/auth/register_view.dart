// ignore_for_file: prefer_const_constructors

import 'dart:developer' as devtools show log;

import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/auth_exceptions.dart';
import 'package:etoet/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  double getWidgetWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  double getWidgetHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double getSpaceRatioToWidgetHeight(BuildContext context,
          {double ratio = 0.02}) =>
      getWidgetHeight(context) * ratio;

  bool emailAlreadyInUse = false;
  bool invalidEmail = false;

  bool passwordRestrictionsSatisfied = false;
  bool weakPassword = false;
  bool passwordMatches = false;
  bool genericException = false;

  /// Group of controllers that handle each of the text field
  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 210, 177, 2),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Create Account ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),

                  Image.asset(
                    'assets/images/helpinghands.png',
                    height: 100,
                    width: 100,
                  ),

                  /// user name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _username,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: ' Username',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: getSpaceRatioToWidgetHeight(context)),

                  /// email
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '  Email',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an email';
                          } else if (invalidEmail) {
                            return 'Please enter a valid email';
                          } else if (emailAlreadyInUse) {
                            return 'Email already in use';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: getSpaceRatioToWidgetHeight(context)),

                  // password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                          controller: _password,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '  Password',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a password';
                            } else if (passwordRestrictionsSatisfied == false) {
                              return 'Please enter a valid password';
                            }
                            return null;
                          }),
                    ),
                  ),
                  // Register button

                  SizedBox(height: getSpaceRatioToWidgetHeight(context)),

                  FlutterPwValidator(
                    controller: _password,
                    minLength: 6,
                    uppercaseCharCount: 2,
                    numericCharCount: 3,
                    specialCharCount: 1,
                    width: getWidgetWidth(context) * 0.8,
                    height: getWidgetHeight(context) * 0.15,
                    defaultColor: Colors.black,
                    // if in langscape mode should be getWidgetWidth(context) * 0.6
                    // but i dont know how to dynamically assigned it yet
                    onSuccess: () {
                      passwordRestrictionsSatisfied = true;
                    },
                  ),

                  SizedBox(height: getSpaceRatioToWidgetHeight(context)),

                  // confirm password again
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _confirmPassword,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: ' Confirm Password',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value != _password.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  // Register button

                  SizedBox(height: getSpaceRatioToWidgetHeight(context)),

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
                          final confirmPassword = _confirmPassword.text;
                          final username = _username.text;

                          if (passwordRestrictionsSatisfied == false) {
                            return;
                          }

                          if (password != confirmPassword) {
                            passwordMatches = false;
                            setState(() {});
                            return;
                          }

                          try {
                            /// show loading while wating for response

                            var user = await AuthService.firebase().createUser(
                              email: email,
                              password: password,
                              displayName: username,
                            );

                            devtools.log(user.toString());

                            setState(() {});

                            AuthService.firebase().sendEmailVerification();
                            Navigator.of(context).pushNamed(verifyEmailRoute);
                          } on EmailAlreadyInUsedAuthException {
                            devtools.log('email already in use');
                            emailAlreadyInUse = true;
                            setState(() {});
                          } on InvalidEmailAuthException {
                            devtools.log('invalid email');
                            invalidEmail = true;
                            setState(() {});
                          } on WeakPassowrdAuthException {
                            devtools.log('weak password');
                            weakPassword = false;
                            setState(() {});
                          } on GenericAuthException {
                            const AlertDialog(
                              title: Text('Generic Error'),
                            );
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    _username = TextEditingController();
    super.initState();
  }
}
