import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/auth_service.dart';
import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/views/auth/login_view.dart';
import 'package:etoet/views/auth/recover_account_view.dart';
import 'package:etoet/views/auth/register_view.dart';
import 'package:etoet/views/friend/add_friend_view.dart';
import 'package:etoet/views/friend/chat_room_view.dart';
import 'package:etoet/views/friend/friend_view.dart';
import 'package:etoet/views/friend/pending_friend_view.dart';
import 'package:etoet/views/main_view.dart';
import 'package:etoet/views/profile/profile_page.dart';
import 'package:etoet/views/settings_view.dart';
import 'package:etoet/views/sign_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        StreamProvider<AuthUser?>(
            initialData: null,
            create: (context) => AuthService.firebase().stream),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)
              .copyWith(secondary: Colors.orangeAccent),
        ),
        home: const SignPost(),

        //define the routes so that the app can navigate to the different views.
        routes: {
          loginRoute: (context) => const LoginView(),
          registerRoute: (context) => const RegisterView(),
          recoverAccountRoute: (context) => const RecoverAccountView(),
          mainRoute: (context) => const MainView(),
          settingsRoute: (context) => const SettingsView(),
          profileRoute: (context) => const ProfilePage(),
          friendRoute: (context) => const FriendView(),
          addFriendRoute: (context) => const AddFriendView(),
          pendingFriendRoute: (context) => const PendingFriendView(),
          // chat_friend_route: (context) => ChatRoomView(),
        },
      ),
    ),
  );
}
