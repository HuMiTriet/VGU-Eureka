import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/views/settingUI_lib/src/settings_list.dart';
import 'package:etoet/views/settingUI_lib/src/settings_section.dart';
import 'package:etoet/views/settingUI_lib/src/settings_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth/auth_user.dart';
import 'package:etoet/services/database/firestore/firestore.dart';

class SettingsView extends StatefulWidget {
  @override
  const SettingsView({Key? key}) : super(key: key);

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  late bool notificationsEnabled ;
  late double _receivedRange;
  late AuthUser? user;
  String? photoURL;

  @override
  Widget build(BuildContext context) {
    user = context.watch<AuthUser?>();
    photoURL = user!.photoURL;
    notificationsEnabled = user?.notificationsEnabled ?? true; // because of the legacy problem, the previous users may not have this field in Firestore
    _receivedRange = (user!.helpRange).toDouble();


    return Scaffold(
      appBar: AppBar(title: const Text('Settings UI')),
      body: buildSettingsList(),
    );
  }

  void showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
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
        });

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
      contentPadding: const EdgeInsets.only(top: 10, bottom:  10),
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
                ),
              ),
            ),
            CustomTile(
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  user!.displayName ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
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
              ),
            SettingsTile.switchTile(
              title: 'Push notifications',
              leading: const Icon(Icons.phonelink_lock),
              switchValue: notificationsEnabled,
              onToggle: (var value) {
                setState(() {
                  //notificationsEnabled = value;
                  user?.notificationsEnabled = value;
                });
                Firestore.updateUserInfo(user!);
              },
              switchActiveColor: Colors.orange,
            ),
            SettingsTile(
                // title: 'Notification-received range',
                titleWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Notification-received range'),
                    Text('${_receivedRange.toStringAsFixed(1)} km'),
                  ],
                ),
                leading: const Icon(Icons.collections_bookmark)),
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
                    //_receivedRange = value;
                    user?.helpRange = value.toInt();
                  });
                  Firestore.updateUserInfo(user!);
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
      ],
    );
  }
}
