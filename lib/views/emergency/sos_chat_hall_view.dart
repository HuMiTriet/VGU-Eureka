import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth/auth_user.dart';

class SOSChatHallView extends StatefulWidget{
  @override
  const SOSChatHallView({Key? key}) : super(key: key);

  @override
  _SOSChatHallViewState createState() => _SOSChatHallViewState();
  
}

class _SOSChatHallViewState extends State<SOSChatHallView> {
  late AuthUser user;
  
  
  @override
  Widget build(BuildContext context) {
    user = context.watch<AuthUser>();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Chat Hall'),
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
      ),
      body: ListView.builder(
        itemCount: 20,
          itemBuilder: (context, index)
              {
                return const ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/etoet-pe2022.appspot.com/o/images%2FDefault.png?alt=media&token=9d2d4b15-cf04-44f1-b46d-ab0f06ab2977'),
                  ),
                  title: Text('Username'),
                  subtitle: Text('email'),
                );
              }
      ),
    );
  }
  
}