import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:etoet/views/settingUI_lib/src/custom_section.dart';
import 'package:etoet/views/settingUI_lib/src/settings_list.dart';
import 'package:etoet/views/settingUI_lib/src/settings_section.dart';
import 'package:etoet/views/settingUI_lib/src/settings_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:settings_ui/settings_ui.dart';

enum MenuAction { signOut }

class SettingsView extends StatefulWidget {
  @override
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool notificationsEnabled = true;
  double _receivedRange = 5.0;
  final String _username = 'Doraemon';

  @override
  Widget build(BuildContext context) {
    var user = context.watch<AuthUser?>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings UI')),
      body: buildSettingsList(),
    );
  }

  Widget buildSettingsList() {
    return SettingsList(
      contentPadding: const EdgeInsets.only(top: 20),
      sections: [
        SettingsSection(
          tiles: [
            SettingsTile(
                titleWidget: CircleAvatar(
                    radius: (50),
                    backgroundColor: Colors.white,
                    // backgroundImage: AssetImage('assets/Doraemon_character.png'),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(49),
                      //image: const AssetImage('assets/images/google_logo.png')
                      child: Image.asset('assets/images/Doraemon.png'),
                    ))),
            CustomTile(
              child: Text(
                _username,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          titlePadding: const EdgeInsets.only(bottom: 50),
        ),
        SettingsSection(
          title: 'Account Setting',
          //titlePadding: EdgeInsets.only(top: 20),
          tiles: [
            const SettingsTile(
                title: 'Edit account',
                leading: Icon(Icons.collections_bookmark)),
            SettingsTile(
                title: 'Logout',
                leading: const Icon(Icons.collections_bookmark),
                onPressed: (_) async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (_) => false,
                  );
                }),
            SettingsTile.switchTile(
              title: 'Push notifications',
              leading: const Icon(Icons.phonelink_lock),
              switchValue: notificationsEnabled,
              onToggle: (var value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            SettingsTile(
              title: 'Notification-received range',
              titleWidget: Slider(
                min: 5,
                max: 20,
                divisions: 5,
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
                value: _receivedRange,
                onChanged: (var value) {
                  setState(() {
                    _receivedRange = value;
                  });
                },
              ),
            )
          ],
        ),
        SettingsSection(
          title: 'More',
          tiles: const [
            SettingsTile(title: 'About us', leading: Icon(Icons.description)),
            SettingsTile(
                title: 'Privacy policy',
                leading: Icon(Icons.collections_bookmark)),
            SettingsTile(
                title: 'Terms of use', leading: Icon(Icons.description)),
          ],
        ),
        CustomSection(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 8),
                child: Image.asset(
                  'assets/images/settings.png',
                  height: 50,
                  width: 50,
                  color: const Color(0xFF777777),
                ),
              ),
              const Text(
                'Version: Beta - Not yet integrate with other parts of the app',
                style: TextStyle(color: Color(0xFF777777)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/*
Widget build(BuildContext context) {
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
 */
