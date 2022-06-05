import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/views/settingUI_lib/src/settings_list.dart';
import 'package:etoet/views/settingUI_lib/src/settings_section.dart';
import 'package:etoet/views/settingUI_lib/src/settings_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:settings_ui/settings_ui.dart';
import '../../services/auth/auth_user.dart';


class SettingsView extends StatefulWidget {
  @override
  const SettingsView({Key? key}) : super(key: key);

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  bool notificationsEnabled = true;
  double _receivedRange = 5.0;
  // String _username = 'Doraemon';
  // String _userName = user!.displayName ?? '';
  late AuthUser? user;
  String? photoURL;



  @override
  Widget build(BuildContext context) {
    user = context.watch<AuthUser?>();
    photoURL = user!.photoURL;
    // String userName = user!.displayName ?? '';
    // String get username => null;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings UI')),
      body: buildSettingsList(),
    );
  }

  void showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
        onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushNamedAndRemoveUntil(
          loginRoute,
          (_) => false,
        );
      }
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you want to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget buildSettingsList() {
    return SettingsList(
      contentPadding: const EdgeInsets.only(top: 20),
      sections: [
        SettingsSection(
          tiles: [
            SettingsTile(
                 titleWidget: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 3),
              // image: ExactAssetImage(widget.user.img),
                    image: DecorationImage(
                        image: NetworkImage(user!.photoURL ??
                    'https://www.pavilionweb.com/wp-content/uploads/2017/03/man-300x300.png'),
                    fit: BoxFit.cover,
              ),
            )),
                //  CircleAvatar(
                //     radius: (50),
                //     backgroundColor: Colors.white,
                //     // backgroundImage: AssetImage('assets/Doraemon_character.png'),
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(49),
                //       //image: const AssetImage('assets/images/google_logo.png')
                //       child:
                //       Image.asset('assets/images/Doraemon.png'),
                //     ))),
            ),
            CustomTile(
              child: Text(
                //username,
                user!.displayName ?? '',
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
                onTap: () => showAlertDialog(context),
                // onPressed: (_) async {
                //   await FirebaseAuth.instance.signOut();
                //   Navigator.of(context).pushNamedAndRemoveUntil(
                //     loginRoute,
                //     (_) => false,
                //   );
                // }

            ),
            SettingsTile.switchTile(
              title: 'Push notifications',
              leading: const Icon(Icons.phonelink_lock),
              switchValue: notificationsEnabled,
              onToggle: (var value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
              switchActiveColor: Colors.orange,
            ),
            SettingsTile(
                // title: 'Notification-received range',
                titleWidget: Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Notification-received range'),
                    Text('${_receivedRange.toStringAsFixed(1)} km'),

                    // Expanded(child: Container()),
                    // Icon(Icons.arrow_drop_down),
                  ],
                ),
                leading: const Icon(Icons.collections_bookmark)
            ),
            SettingsTile(
              titleWidget: Slider(
                min: 5,
                max: 20,
                divisions: 3,
                activeColor: Colors.orange,
                inactiveColor: Colors.grey,
                value: _receivedRange,
                onChanged: (var value) {
                  setState(() {
                    _receivedRange = value;
                  });
                },
                label: '$_receivedRange km',
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
        // CustomSection(
        //   child: Column(
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.only(top: 15, bottom: 8),
        //         child: Image.asset(
        //           'assets/images/settings.png',
        //           height: 50,
        //           width: 50,
        //           color: const Color(0xFF777777),
        //         ),
              //),
              // const Text(
              //   'Version: Beta - Not yet integrate with other parts of the app',
              //   style: TextStyle(color: Color(0xFF777777)),
              // ),
            //],
         // ),
        //),
      ],
    );
  }

  void showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text('No'),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text('Yes'),
        onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushNamedAndRemoveUntil(
          loginRoute,
          (_) => false,
        );
      }
    );

    // set up the AlertDialog
    var alert = AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
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
