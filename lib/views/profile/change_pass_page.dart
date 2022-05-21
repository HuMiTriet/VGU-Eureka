import 'package:etoet/views/profile/verification_view.dart';
import 'package:flutter/material.dart';

import '../../services/auth/auth_user.dart';

class ChangePassPage extends VerificationView {
  const ChangePassPage({
    Key? key,
    required String title,
    required AuthUser user,
  }) : super(
          key: key,
          title: title,
          user: user,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
      /// for the appbar
      Container(
          height: 50,
          color: const Color.fromARGB(255, 247, 224, 120),
          child: Row(children: <Widget>[
            TextButton(
                child: const Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                }),
            Text(title, style: const TextStyle(fontSize: 20))
          ])),

      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
          child: Column(children: <Widget>[
            // text field for input password
            const TextField(
                decoration: InputDecoration(label: Text('Current Password'))),

            const SizedBox(height: 20),
            // text field for input new password
            const TextField(
                decoration: InputDecoration(label: Text('New Password'))),
            const SizedBox(height: 20),

            // text field for input comfirm password
            const TextField(
                decoration:
                    InputDecoration(label: Text('Confirm New Password'))),

            const SizedBox(height: 20),

            TextButton(
                child: const Text('Save'),
                style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 247, 224, 120)),
                onPressed: () {})
          ]),
        ),
      ),
    ])));
  }
}
