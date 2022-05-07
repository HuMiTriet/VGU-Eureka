import 'package:flutter/material.dart';

class Change_Pass_Page extends StatelessWidget {
  const Change_Pass_Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
      /// for the appbar
      Container(
          height: 50,
          color: Color.fromARGB(255, 247, 224, 120),
          child: Row(children: <Widget>[
            TextButton(
                child: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                }),
            Text('Change Password', style: TextStyle(fontSize: 20))
          ])),

      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
          child: Container(
              child: Column(children: <Widget>[
            // text field for input password
            TextField(
                decoration: InputDecoration(label: Text('Current Password'))),

            SizedBox(height: 20),
            // text field for input new password
            TextField(decoration: InputDecoration(label: Text('New Password'))),
            SizedBox(height: 20),

            // text field for input comfirm password
            TextField(
                decoration:
                    InputDecoration(label: Text('Confirm New Password'))),

            SizedBox(height: 20),

            TextButton(
                child: Text('Save'),
                style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 247, 224, 120)),
                onPressed: () {})
          ])),
        ),
      ),
    ])));
  }
}
