import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    var user = context.watch<AuthUser?>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
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
          ListTile(
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(user!.photoURL ?? '')),
              title: Text(user.displayName ?? 'name'),
              subtitle: Text(user.email ?? 'email')),
        ],
      ),
    );
  }
}
