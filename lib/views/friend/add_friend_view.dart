// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AddFriendView extends StatefulWidget {
  const AddFriendView({Key? key}) : super(key: key);

  @override
  State<AddFriendView> createState() => _AddFriendViewState();
}

class _AddFriendViewState extends State<AddFriendView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Text('Add By Phone Number',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          )),
      SizedBox(height: 30),
      TextField(
          decoration: InputDecoration(
            fillColor: Color.fromARGB(255, 238, 235, 227),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
            // errorBorder: InputBorder.none,
            // focusedBorder: InputBorder.none,
            // enabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            filled: true,
            hintText: 'Enter Phone Number',
          ),
          keyboardType: TextInputType.number),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(
            icon: Icon(Icons.cancel_rounded, size: 30), onPressed: () {}),
        IconButton(icon: Icon(Icons.check_circle, size: 30), onPressed: () {}),
      ])
    ]));
  }
}
