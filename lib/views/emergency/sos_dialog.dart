import 'package:flutter/material.dart';

 class SosDialog extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: ElevatedButton(
         child: const Text('This is a marker'),
         onPressed: () {
           showAlertDialog(context);
         },
       ),
     );
   }
 }

 showAlertDialog(BuildContext context) {

   // set up the buttons
   Widget sendmessageButton = ElevatedButton(
       onPressed: () {},
       style: ElevatedButton.styleFrom(
           primary: Colors.blue,
           padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
           textStyle: const TextStyle(
               fontSize: 15,
               fontWeight: FontWeight.bold)),
       child: const Text('SEND MESSAGE'),
   );
   Widget helpButton = ElevatedButton(
     onPressed: () {},
     style: ElevatedButton.styleFrom(
         primary: Colors.red,
         padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
         textStyle: const TextStyle(
             fontSize: 15,
             fontWeight: FontWeight.bold)),
     child: const Text('HELP'),
   );

   // set up the AlertDialog
   AlertDialog alert = AlertDialog(
     title: Column(
       crossAxisAlignment: CrossAxisAlignment.stretch,
       children: <Widget>[
         Row(
           mainAxisAlignment: MainAxisAlignment.end,
         children: <Widget>[ IconButton(
               icon: const Icon(Icons.close),
               color: Colors.grey,
               iconSize: 25,
               onPressed: () {
               Navigator.pop(context);
               },
             ),
           ],
         ),
         const Text("Emergency"),
       ],
     ),
     content: const Text("I need help!!!!"
         "\nI want my mom back."
         " This app is so wonderful."),
     actions: [
       sendmessageButton,
       helpButton,
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
