import 'package:etoet/firebase_options.dart';
import 'package:etoet/views/auth/verified_email_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;

              if (user?.emailVerified ?? false) {
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const VerifiedEmailView(),
                ));
              }

              return const Text('Firebase initlized');
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
