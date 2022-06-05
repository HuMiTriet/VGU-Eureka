import 'package:etoet/services/auth/user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth/auth_user.dart';

// just put here for the color reference, the tool is not good enought to generate the working code but it's ok for getting the color
class FvColors {
  static const Color screen1Background = Color.fromARGB(0,0,0,0);
  static const Color container2Background = Color.fromARGB(255,199,9,9);
  static const Color imageview3Background = Color.fromARGB(255,255,255,255);
  static const Color textview4FontColor = Color.fromARGB(255,0,0,0);
  static const Color button6Background = Color.fromARGB(255,132,2,2);
}

class Confirmbox extends StatefulWidget {
  final double distance;
  final UserInfo needHelpUser;
  // just for testing
  static const mockUser = UserInfo(uid: 'CXIipI6L4xb2rfyDTvp7Dj0MIxs2');

  Confirmbox({
    Key? key,
    this.distance = 5.0,
    this.needHelpUser = mockUser,
  }) : super(key: key);

  @override
  _ConfirmboxState createState() => _ConfirmboxState();
}

class _ConfirmboxState extends State<Confirmbox> {
  late AuthUser? needHelpUser;
  String? photoURL;
  String? displayName;
  String? email;


  @override
  Widget build(BuildContext context) {
    double _distance = widget.distance;
    UserInfo _needHelpUser = widget.needHelpUser;
    needHelpUser = context.watch<AuthUser?>();
    photoURL = needHelpUser?.photoURL;
    displayName = needHelpUser?.displayName;
    email = needHelpUser?.email;

    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Container(
      height: 300,
      //color: Colors.red,
      decoration: BoxDecoration(
          color: FvColors.container2Background,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft:  Radius.circular(20.0))),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 5),
            height: 30,
            child: Text('$_distance km away from you',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
          Container(
            height: 200,
            width: 370,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),

            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(photoURL ??
                                  'https://www.pavilionweb.com/wp-content/uploads/2017/03/man-300x300.png'),
                              fit: BoxFit.cover,
                            ),
                          )),

                      Expanded(child: Container(
                        alignment: Alignment.centerLeft,
                        // margin: EdgeInsets.only(left: -5),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text('$displayName',
                                  textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0, top: 3.0),
                              child: Text('$email',
                                  textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            ),
                        ]),
                      )),
                      IconButton(
                        icon: const Icon(Icons.message),
                        onPressed: (){},
                      )],
                  )
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 10,right: 10),
                  height: 30,
                  child: Row(
                    children: <Widget>[ Text('Emergency! - ', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('Lost and Found', style: TextStyle(color: Colors.grey),)],
                  )
                ),
                Container(
                  width: 360.0,
                  height: 110.0,
                  padding: EdgeInsets.only(left: 5,right: 5),
                  color: Colors.transparent,
                  alignment: Alignment.topCenter,

                  child: SingleChildScrollView(
    scrollDirection: Axis.vertical,//.horizontal
    child: new Text(
    "This SOS Notification Dummy Text is too long, didn't read, but you can scroll down " +
    "and see the text. This SOS Notification Dummy Text is too long, didn't read, but you can scroll down " +"This SOS Notification Dummy Text is too long, didn't read, but you can scroll down " +
    "and see the text. This SOS Notification Dummy Text is too long, didn't read, but you can scroll down " +"This SOS Notification Dummy Text is too long, didn't read, but you can scroll down " +
    "and see the text. This SOS Notification Dummy Text is too long, didn't read, but you can scroll down " +"This SOS Notification Dummy Text is too long, didn't read, but you can scroll down " +
    "and see the text. This SOS Notification Dummy Text is too long, didn't read, but you can scroll down ",
    style: new TextStyle(
    fontSize: 16.0, color: Colors.black,
                )
    ),))
              ],
            ),
          ),
        Container(
            width: 300,
            height: 39,
            margin: EdgeInsets.only(top: 10),

            child: TextButton(
            child: Text('Confirm help ${displayName}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: FvColors.imageview3Background,
                    fontWeight: FontWeight.w700,
                  )),
              style: TextButton.styleFrom(
                backgroundColor: FvColors.button6Background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    width: 0,
                    color: Colors.transparent,
                  ),
                ),
              ),
              onPressed: () {},
            )
        )
        ],
      ),
    );
  }
}
        