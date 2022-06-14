// ignore_for_file: prefer_const_constructors, unnecessary_new

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
import 'package:provider/provider.dart';

import '../../services/database/firestore/firestore.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  double getWidgetWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  double getWidgetHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double getSpaceRatioToWidgetHeight(BuildContext context,
          {double ratio = 0.02}) =>
      getWidgetHeight(context) * ratio;

  late final TextEditingController _email;
  late final TextEditingController _password;
  GoogleSignInAccount? _googleUser;
  GoogleSignInAuthentication? _googleAuth;

  bool userNotFound = false;
  bool invalidEmail = false;
  bool wrongPassword = false;

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
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
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
                    height: 100,
                    width: 100,
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
                            return 'Please enter your email';
                          } else if (invalidEmail) {
                            return 'Please enter a valid email';
                          } else if (userNotFound) {
                            return 'User not found';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  SizedBox(
                    height: getSpaceRatioToWidgetHeight(context),
                  ),

                  // password text field
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
                        enableSuggestions: false,
                        obscureText: true,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '  Password',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          } else if (wrongPassword) {
                            return 'Wrong password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  SizedBox(
                    height: getSpaceRatioToWidgetHeight(context),
                  ),

                  // Sign in button
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

                          devtools.log('Login button pressed');

                          try {
                            await AuthService.firebase().login(
                              email: email,
                              password: password,
                            );

                            final user =
                                Provider.of<AuthUser?>(context, listen: false);

                            devtools.log(user.toString());

                            setState(() {});

                            if (user?.isEmailVerified ?? false) {
                              // user is verified
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainView(),
                                ),
                                (route) => false,
                              );
                            } else {
                              // user is NOT verified
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                verifyEmailRoute,
                                (route) => false,
                                arguments: user,
                              );
                            }
                          } on UserNotFoundAuthException {
                            devtools.log('user not found');
                            userNotFound = true;
                            setState(() {});
                          } on WrongPasswordAuthException {
                            devtools.log('wrong password');
                            wrongPassword = true;
                            setState(() {});
                          } on InvalidEmailAuthException {
                            invalidEmail = true;
                            setState(() {});
                          } on FirebaseException catch (e) {
                            devtools.log(e.toString());
                            await showErrorDialog(context, 'Error');
                          }
                        },
                        child: const Center(
                            child: Text(
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
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 15.0),
                            child: Divider(
                              color: Colors.black,
                              height: 0.5,
                            )),
                      ),
                      Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 15.0),
                            child: Divider(
                              color: Colors.black,
                              height: 0.5,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _Button(
                      color: Colors.black,
                      image: const AssetImage('assets/images/google_logo.png'),
                      text: 'Sign in with Google',
                      onPressed: signInWithGoogle),
                  const SizedBox(
                    height: 10,
                  ),
                  _Button(
                      color: Colors.black,
                      image:
                          const AssetImage('assets/images/facebook_logo.png'),
                      text: 'Sign in with Facebook',
                      onPressed: signInWithFacebook),
                  //switch to the register view
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
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
                            'Sign Up',
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
    var userExists = Firestore.userExists(authUser.uid);
    userExists.then((value) => {
          if (value)
            {Firestore.updateUserInfo(authUser)}
          else
            {Firestore.addUserInfo(authUser)}
        });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MainView(),
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
        var userExists = Firestore.userExists(authUser.uid);
        userExists.then((value) => {
              if (value)
                {Firestore.updateUserInfo(authUser)}
              else
                {Firestore.addUserInfo(authUser)}
            });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainView(),
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
          constraints: const BoxConstraints.tightForFinite(
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
                    const SizedBox(width: 15),
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
