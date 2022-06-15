import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Dialog 1
void showSolvedDialog(BuildContext context) {
  // set up the buttons
  Widget notGetHelpButton = Container(
    height: 30,
    width: 100,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      color: Colors.red,
    ),
    child: TextButton(
      child: const Text(
        'NO, I DID NOT GET HELP!',
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
        Navigator.of(context).pop();
      },
    ),
  );

  // set up the AlertDialog
  var alert = AlertDialog(
    title: const Text(
      'YOUR PROBLEM HAS BEEN SOLVED!',
      style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w800,
          color: Colors.green),
    ),
    content: const Text('The person who helped you has confirmed that your problem has been resolved. Please confirm to turn off your signal.'),
    actions: [
      notGetHelpButton,
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

// Dialog 2
void showOopsDialog(BuildContext context) {
  // set up the buttons
  Widget noButton = Container(
    height: 30,
    width: 100,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      color: Colors.grey,
    ),
    child: TextButton(
      child: const Text(
        'NO, MY PROBLEM IS SOLVED',
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
  Widget yesButton = Container(
    height: 30,
    width: 100,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      color: Colors.red,
    ),
    child: TextButton(
      child: const Text(
        'YES, I DO',
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

  // set up the AlertDialog
  var alert = AlertDialog(
    title: const Text(
      'OOPS!',
      style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w800,
          color: Colors.red),
    ),
    content: const Text('Unfortunately, this person has aborted your signal. Do you still need help?'),
    actions: [
      noButton,
      yesButton,
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