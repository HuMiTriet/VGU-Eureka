// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_single_quotes

import 'dart:developer' as devtools show log;

import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/auth_exceptions.dart';
import 'package:etoet/services/auth/auth_service.dart';
import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/views/auth/error_dialog.dart';
import 'package:etoet/views/main_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  GoogleSignInAccount? _googleUser;
  GoogleSignInAuthentication? _googleAuth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 210, 177, 2),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ' Welcome to ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      'ETOET',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 210, 177, 2),
                      ),
                    ),
                  ),
                ],
              ),
              Image.asset(
                'assets/images/helpinghands.png',
                width: 50,
                height: 70,
              ),

              //Email or phonenumber text field
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
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '  Email or phone number',
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // password text field
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
                    enableSuggestions: false,
                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '  Password',
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Sign in button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints.tightForFinite(
                    width: 250,
                    height: 40,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(227, 252, 126, 0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        await AuthService.firebase().login(
                          email: email,
                          password: password,
                        );

                        final user = AuthService.firebase().currentUser;
                        if (user?.isEmailVerified ?? false) {
                          // user is verified
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            mainRoute,
                            (route) => false,
                          );
                        } else {
                          // user is NOT verified
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            verifyEmailRoute,
                            (route) => false,
                          );
                        }
                      } on UserNotFoundAuthException {
                        await showErrorDialog(context, 'User not found');
                      } on WrongPasswordAuthException {
                        await showErrorDialog(context, 'Incorrect password');
                      } on GenericAuthException {
                        await showErrorDialog(context, 'Error');
                      }
                    },
                    child: Center(
                        child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )),
                  ),
                ),
              ),

              // Forgot password?
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        recoverAccountRoute,
                      );
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                        child: Divider(
                          color: Colors.black,
                          height: 0.3,
                        )),
                  ),
                  Text(
                    "OR",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                        child: Divider(
                          color: Colors.black,
                          height: 0.3,
                        )),
                  ),
                ],
              ),
              SizedBox(height: 5),

              _Button(
                  color: Colors.black,
                  image: const AssetImage('assets/images/google_logo.png'),
                  text: 'Sign in with Google',
                  onPressed: signInWithGoogle),
              SizedBox(height: 10),
              _Button(
                  color: Colors.black,
                  image: const AssetImage('assets/images/facebook_logo.png'),
                  text: 'Sign in with Facebook',
                  onPressed: signInWithFacebook),
              //switch to the register view
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Do not have an account?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute,
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Create an account',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            decoration: TextDecoration.underline),
                      )),
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
    super.dispose();
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    _googleUser = await GoogleSignIn(
      clientId:
          '344264346912-1qh85k7a5tpslbfk37p0ojs3hfik6t10.apps.googleusercontent.com',
      scopes: <String>[
        'email',
      ],
    ).signIn();

    // Obtain the auth details from the request
    _googleAuth = await _googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: _googleAuth?.accessToken,
      idToken: _googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final user = (await FirebaseAuth.instance.signInWithCredential(credential))
        .user as User;
    final authUser = AuthUser(
        isEmailVerified: user.emailVerified,
        uid: user.uid,
        email: user.email,
        phoneNumber: user.phoneNumber,
        displayName: user.displayName);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MainView(user: authUser),
      ),
      (route) => false,
    );
  }

  Future<void> signInWithFacebook() async {
    // Create an instance of FacebookLogin
    final fb = FacebookLogin(debug: true);

    // Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    // Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
        // Logged in

        // Send access token to server for validation and auth
        final accessToken = res.accessToken;
        devtools.log('Access token: ${accessToken?.token}');

        // Get profile data
        final profile = await fb.getUserProfile();
        devtools.log('Hello, ${profile!.name}! You ID: ${profile.userId}');

        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        devtools.log('Your profile image: $imageUrl');

        // Get email (since we request email permission)
        final email = await fb.getUserEmail();
        // But user can decline permission
        if (email != null) {
          devtools.log('And your email is $email');
        }
        var cred = FacebookAuthProvider.credential(accessToken!.token);
        final user = (await FirebaseAuth.instance.signInWithCredential(cred))
            .user as User;
        final authUser = AuthUser(
            isEmailVerified: user.emailVerified,
            uid: user.uid,
            email: user.email,
            phoneNumber: user.phoneNumber,
            displayName: user.displayName);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainView(user: authUser),
          ),
          (route) => false,
        );
        break;
      case FacebookLoginStatus.cancel:
        // User cancel log in
        devtools.log('Login aborted',
            name: 'login_view.dart: signInWithFacebook');
        break;
      case FacebookLoginStatus.error:
        // Log in failed
        devtools.log('Error while log in: ${res.error}');
        break;
    }
  }
}

class _Button extends StatelessWidget {
  final Color color;
  final ImageProvider image;
  final String text;
  final VoidCallback onPressed;

  const _Button({
    required this.color,
    required this.image,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints.tightForFinite(
            width: 250,
            height: 43,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const SizedBox(width: 5),
              Image(
                image: image,
                width: 25,
                height: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    const SizedBox(width: 35),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
