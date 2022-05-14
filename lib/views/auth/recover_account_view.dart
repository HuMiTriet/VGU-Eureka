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
          title: const Text('Recover Account'),
        ),
        body: Column(children: <Widget>[
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Email',
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
            child: const Text('Send Recovery Email'),
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
