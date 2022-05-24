// ignore_for_file: prefer_const_constructors

import 'dart:developer' as devtools show log;

import 'package:etoet/views/auth/error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecoverAccountView extends StatefulWidget {
  const RecoverAccountView({
    Key? key,
  }) : super(key: key);

  @override
  State<RecoverAccountView> createState() => _RecoverAccountViewState();
}

class _RecoverAccountViewState extends State<RecoverAccountView> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Forgot your password ?',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.orange,
        ),
        backgroundColor: Color.fromRGBO(255, 210, 177, 2),
        body: Column(children: <Widget>[
          SizedBox(height: 20),
          Text(
            'Enter your registered email below to recieve password instruction',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.grey,
            ),
          ),
          Image.asset(
            'assets/images/Email_icon.png',
            width: 100,
            height: 150,
          ),
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
                  hintText: '  Email',
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              resetPassword();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
            ),
            child: const Text('Send'),
          ),
        ]));
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _email.text.trim());
      await showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Recovery Email Sent'),
          content: Text('Recovery Email Sent to ' + _email.text.trim()),
        ),
      );

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      devtools.log('$e', name: 'RecoverAccountView');
      switch (e.code) {
        case 'invalid-email':
          await showErrorDialog(context, 'Invalid email');
          break;

        default:
          await showErrorDialog(context, 'Error: ${e.code}');
          break;
      }
    }
  }
}
