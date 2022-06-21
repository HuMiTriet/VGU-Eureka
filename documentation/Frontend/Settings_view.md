# Introduction
To let the users custom their setting about account, notificatoin, received ranged, and logout the account in a convenient way, I use the setting ui library from pub.dev[[1]](https://pub.dev/packages/settings_ui) and other widgets to display user information and send the setting of user to the database stored in Firebase. For testing purpose, the edit profile feature currently stays in the mainview and not link to the edit account section.

## How to use
- First, add the dependency in your pubspec.yaml file:
```dart
dependencies:  
 settings_ui: <latest version>
```
- Then, import the settings_ui package:
```dart
import 'package:settings_ui/settings_ui.dart';
```



1. Pub.dev, Settings UI, from:https://pub.dev/packages/settings_ui 
