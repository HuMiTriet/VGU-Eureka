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
    );
  }
  
}