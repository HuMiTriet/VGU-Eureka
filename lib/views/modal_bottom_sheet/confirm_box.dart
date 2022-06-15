import 'package:etoet/services/auth/user_info.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:provider/provider.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:uuid/uuid.dart';

import '../../services/auth/auth_user.dart';
import '../../services/database/firestore/firestore_SOS_chat.dart';
import '../emergency/sos_chat_room_view.dart';

class Confirmbox extends StatefulWidget {
  final double distance;
  final etoet.UserInfo needHelpUser;
  final String locationDescription;
  final String situationDetail;
  final String emergencyType;
  final Function onHelpButtonPressed;
  final Function onAbortButtonPressed;
  final Function onDoneButtonPressed;
  bool confirmedToHelp;
  Confirmbox({
    Key? key,
    required this.distance,
    required this.needHelpUser,
    required this.locationDescription,
    required this.situationDetail,
    required this.emergencyType,
    required this.onHelpButtonPressed,
    required this.onAbortButtonPressed,
    required this.onDoneButtonPressed,
    this.confirmedToHelp = false,
  }) : super(key: key);

  @override
  State<Confirmbox> createState() => _ConfirmboxState();
}

// just put here for the color reference, the tool is not good enought to generate the working code but it's ok for getting the color
class FvColors {
  static const Color screen1Background = Color.fromARGB(0, 0, 0, 0);
  static const Color container2Background = Color.fromARGB(255, 199, 9, 9);
  static const Color imageview3Background = Color.fromARGB(255, 255, 255, 255);
  static const Color textview4FontColor = Color.fromARGB(255, 0, 0, 0);
  static const Color button6Background = Color.fromARGB(255, 132, 2, 2);
}

class _ConfirmboxState extends State<Confirmbox> {


  late AuthUser user;

  @override
  Widget build(BuildContext context) {
    var distance = widget.distance;

    user = context.watch<AuthUser>();

    void showAbortDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = Container(
        height: 30,
        width: 100,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Color.fromRGBO(66, 133, 244, 1),
        ),
        child: TextButton(
          child: const Text(
            'CANCEL',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.9800000190734863),
                fontFamily: 'Poppins',
                fontSize: 12,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
      Widget confirmButton = Container(
        height: 30,
        width: 100,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Color(0xff34a853),
        ),
        child: TextButton(
          child: const Text(
            'CONFIRM',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.9800000190734863),
                fontFamily: 'Poppins',
                fontSize: 12,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          onPressed: () {
            widget.onAbortButtonPressed();
            Navigator.of(context).pop();
          },
        ),
      );

      // set up the AlertDialog
      var alert = AlertDialog(
        title: const Text(
          'ABORT',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
              color: Colors.red),
        ),
        content: const Text('Abort helping this person ?'),
        actions: [
          cancelButton,
          confirmButton,
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

    void showDoneDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = Container(
        height: 30,
        width: 100,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Color.fromRGBO(66, 133, 244, 1),
        ),
        child: TextButton(
          child: const Text(
            'CANCEL',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.9800000190734863),
                fontFamily: 'Poppins',
                fontSize: 12,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
      Widget confirmButton = Container(
        height: 30,
        width: 100,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Color(0xffadadad),
        ),
        child: TextButton(
          child: const Text(
            'CONFIRM',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.9800000190734863),
                fontFamily: 'Poppins',
                fontSize: 12,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          onPressed: () {
            widget.onDoneButtonPressed();
            Navigator.of(context).pop();
          },
        ),
      );

      // set up the AlertDialog
      var alert = AlertDialog(
        title: const Text(
          'DONE',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
              color: Colors.red),
        ),
        content: const Text('Did you help this person ?'),
        actions: [
          cancelButton,
          confirmButton,
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

    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Container(
      alignment: Alignment.center,
      height: 300,
      //color: Colors.red,
      decoration: const BoxDecoration(
          color: FvColors.container2Background,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 5),
            height: 30,
            child: Text('$distance km away from you',
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
          Container(
            height: 200,
            width: 370,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    height: 50,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(widget.needHelpUser.photoURL ??
                                  'https://www.pavilionweb.com/wp-content/uploads/2017/03/man-300x300.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          alignment: Alignment.centerLeft,
                          // margin: EdgeInsets.only(left: -5),
                          child: Column(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text('${widget.needHelpUser.displayName}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, top: 3.0),
                              child: Text('${widget.needHelpUser.email}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ]),
                        )),
                        IconButton(
                          // Send message to helpee
                          icon: const Icon(Icons.message),
                          onPressed: () async {
                            toPublicSOSChatView();
                          },
                        ),
                        if (widget.confirmedToHelp)
                          IconButton(
                              icon: const Icon(Icons.phone),
                              onPressed: () {
                                //launchUrlString('tel:${phoneNumber ?? '113'} ');                              })
                                launchUrlString('tel:phoneNumber');                              })
                      ],
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    height: 30,
                    child: Row(
                      children: <Widget>[
                        const Text(
                          'Emergency! - ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.emergencyType,
                          style: const TextStyle(color: Colors.grey),
                        )
                      ],
                    )),
                Container(
                    width: 360.0,
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical, //.horizontal
                      child: Text('Situation: ${widget.situationDetail}'
                          '\n'
                          'Location: ${widget.locationDescription}'),
                    ))
              ],
            ),
          ),
          //   Widget swapWidget = new Container();
          if (!widget.confirmedToHelp)
            Container(
                width: 300,
                height: 39,
                margin: const EdgeInsets.only(top: 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: FvColors.button6Background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: const BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  onPressed: () {
                    widget.onHelpButtonPressed();
                    setState(() {
                      widget.confirmedToHelp = true;
                    });
                  },
                  child: Text('Confirm help ${widget.needHelpUser.displayName}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        color: FvColors.imageview3Background,
                        fontWeight: FontWeight.w700,
                      )),
                ))
          else
            Container(
              width: 300,
              height: 39,
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 142,
                      height: 33,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(0, 4),
                              blurRadius: 4)
                        ],
                        color: Color.fromRGBO(176, 176, 176, 1),
                      ),
                      child: TextButton(
                        child: const Text(
                          'ABORT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(
                                  255, 255, 255, 0.9800000190734863),
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                        onPressed: () {
                          showAbortDialog(context);
                        },
                      )),
                  Container(
                      width: 142,
                      height: 33,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(0, 4),
                              blurRadius: 4)
                        ],
                        color: Color.fromRGBO(52, 168, 83, 1),
                      ),
                      child: TextButton(
                        child: const Text(
                          'DONE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(
                                  255, 255, 255, 0.9800000190734863),
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                        onPressed: () {
                          showDoneDialog(context);
                        },
                      ))
                ],
              ),
            )
          //swapWidget
        ],
      ),
    );
  }

  void toPublicSOSChatView() async {
    var chatroomUID = const Uuid().v4().toString();
    print(chatroomUID);
    await FirestoreSOSChat.createSOSChatroom(
        user.uid, widget.needHelpUser.uid, chatroomUID);
    print('create chatroom complete');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SOSChatRoomView(widget.needHelpUser)),
    );
  }

}
