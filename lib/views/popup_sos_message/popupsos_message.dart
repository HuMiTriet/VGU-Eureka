// import 'package:flutter/material.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter',
//       home: Scaffold(
//           appBar: AppBar(
//             title: Text('Flutter'),
//           ),
//           body: MyLayout()),
//     );
//   }
// }
//
// class MyLayout extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ElevatedButton(
//         child: Text('This is a marker'),
//         onPressed: () {
//           showAlertDialog(context);
//         },
//       ),
//     );
//   }
// }
//
// showAlertDialog(BuildContext context) {
//
//   // set up the buttons
//   Widget sendmessageButton = ElevatedButton(
//       child: Text('SEND MESSAGE'),
//       onPressed: () {},
//       style: ElevatedButton.styleFrom(
//           primary: Colors.blue,
//           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
//           textStyle: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.bold)),
//   );
//   Widget helpButton = ElevatedButton(
//     child: Text('HELP'),
//     onPressed: () {},
//     style: ElevatedButton.styleFrom(
//         primary: Colors.red,
//         padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
//         textStyle: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.bold)),
//   );
//
//   // set up the AlertDialog
//   AlertDialog alert = AlertDialog(
//     title: Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: <Widget>[
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[ IconButton(
//               icon: Icon(Icons.close),
//               color: Colors.grey,
//               iconSize: 25,
//               onPressed: () {
//               Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//         Text("Emergency"),
//       ],
//     ),
//     content: Text("I need help!!!!"
//         "\nI want my mom back."
//         " This app is so wonderful."),
//     actions: [
//       sendmessageButton,
//       helpButton,
//     ],
//   );
//
//   // show the dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }