// ignore_for_file: prefer_const_constructors

import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/database/database.dart';
import 'package:etoet/services/database/firestore.dart';
import 'package:flutter/material.dart';

import '../../services/auth/auth_service.dart';
import '../../services/auth/auth_user.dart';

class VerifyEmailView extends StatefulWidget {
  final AuthUser user;

  const VerifyEmailView({Key? key, required this.user}) : super(key: key);

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    var userExists = Firestore.userExists(widget.user.uid) as bool;
    if (!userExists) {
      Firestore.addUserInfo(widget.user);
    }
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 210, 177, 2),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text('Email has been sent!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
              Text(
                'Please check your inbox and click in the recieved link to reset the password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 20),

              Image.asset(
                'assets/images/Email-vertification.png',
                width: 100,
                height: 150,
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Did not recieve email ?',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  TextButton(
                    onPressed: () async {
                      await AuthService.firebase().sendEmailVerification();
                    },
                    child: const Text(
                      'Resend',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              //sign up button
              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints.tightForFinite(
                    width: 100,
                    height: 40,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(227, 252, 126, 0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                      onPressed: () async {
                        await AuthService.firebase().logOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute,
                          (route) => false,
                        );
                      },
                      child: const Center(
                        child: Text('Return to Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
