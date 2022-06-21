# Introduction
To let the users custom their setting about account, notificatoin, received ranged, and logout the account in a convenient way, I use the setting ui library from pub.dev[[1]](https://pub.dev/packages/settings_ui) and other widgets to display user information and send the setting of user to the database stored in Firebase. For testing purpose, the edit profile feature currently stays in the mainview and not link to the edit account section.

## Settings UI
### How to use
- First, add the dependency in your pubspec.yaml file:
```dart
dependencies:  
 settings_ui: <latest version>
```
- Then, import the settings_ui package:
```dart
import 'package:settings_ui/settings_ui.dart';
```
- Basic usage:
```dart
SettingsList(
      sections: [
        SettingsSection(
          title: Text('Common'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.language),
              title: Text('Language'),
              value: Text('English'),
            ),
            SettingsTile.switchTile(
              onToggle: (value) {},
              initialValue: true,
              leading: Icon(Icons.format_paint),
              title: Text('Enable custom theme'),
            ),
          ],
        ),
      ],
    ),
```
&mdash; SettingsList is the most outter wrapper and it actually is a ListView from inside. It contains multiple sections that can be SettingsSections or CustomSections.
&mdash; SettingSection is the block of your settings tiles located in the SettingsList.
&mdash; SettingsTile is the implementation of AbstractSettingsTile. It has a lot of fabric methods and parameters that help us add and custome widget the way we want.


1. Pub.dev, Settings UI, from:https://pub.dev/packages/settings_ui 
