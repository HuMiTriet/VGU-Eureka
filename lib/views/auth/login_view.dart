import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/auth_exceptions.dart';
import 'package:etoet/services/auth/auth_service.dart';
import 'package:etoet/views/auth/error_dialog.dart';
import 'package:etoet/views/main_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text('Login'),
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
                await AuthService.firebase().login(
                  email: email,
                  password: password,
                );

                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  // user is verified
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainView(user: user!),
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
                await showErrorDialog(context, 'User not found');
              } on WrongPasswordAuthException {
                await showErrorDialog(context, 'Incorrect password');
              } on GenericAuthException {
                await showErrorDialog(context, 'Error');
              }
            },
            child: const Text('Login'),
          ),
          //switch to the register view
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Not registered yet ? Sign Up')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                recoverAccountRoute,
              );
            },
            child: const Text('Forgot your Password?'),
          ),
          _Button(
              color: Colors.green,
              image: const AssetImage('assets/images/google_logo.png'),
              text: 'Login with Google',
              onPressed: signInWithGoogle),
        ],
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
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil(mainRoute, (route) => false);
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
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const SizedBox(width: 5),
              Image(
                image: image,
                width: 25,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(text, style: TextStyle(color: color, fontSize: 18)),
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
