import 'package:etoet/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';

enum MenuAction { signOut }

class SettingsView extends StatefulWidget {
  @override
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
                'Log Out',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
                'Log out of the account',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                    (_) => false,
              );
            },
          ),
        ],
      ),

    );
  }

}