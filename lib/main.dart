import 'package:etoet/views/auth/login_view.dart';
import 'package:etoet/views/auth/register_view.dart';
import 'package:etoet/views/home_page_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePageView(),

      //define the routes so that the app can navigate to the different views.
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ),
  );
}
