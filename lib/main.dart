import 'package:etoet/views/auth/login_view.dart';
import 'package:etoet/views/auth/register_view.dart';
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
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ),
  );
}
