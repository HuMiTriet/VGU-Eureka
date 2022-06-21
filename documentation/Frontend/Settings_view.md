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
#### SettingsList is the most outter wrapper and it actually is a ListView from inside. It contains multiple sections that can be SettingsSections or CustomSections.
#### SettingSection is the block of your settings tiles located in the SettingsList.
#### SettingsTile is the implementation of AbstractSettingsTile. It has a lot of fabric methods and parameters that help us add and custome widget the way we want.

## Slider
### How to use
- Import the material dart package:
```dart
import 'package:flutter/material.dart';
```
- Usage:
```dart
Slider(
  min: 5,
  max: 20,
  divisions: 3,
  activeColor: Colors.orange,
  inactiveColor: Colors.grey,
  value: _receivedRange,
  onChanged: (var value) {
    setState(() {
      user?.helpRange = value.toInt();
    });
    Firestore.updateUserInfo(user!);
  },
  label: '$_receivedRange km',
)
```
In this project, we use Slider to let the user choose their wanted notificatoin received range.


1. Pub.dev, Settings UI, from https://pub.dev/packages/settings_ui 
2. Flutter.dev, Slider class, from https://api.flutter.dev/flutter/material/Slider-class.html
