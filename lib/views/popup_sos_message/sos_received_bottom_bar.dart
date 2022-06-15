// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class SoSReceivedBottomSheet extends StatefulWidget {
  final String helperDisplayName;
  final String helperUID;
  final String helperEmail;
  final String helperPhoneNumber;
  final String helperPhotoURL;
  SoSReceivedBottomSheet({
    required this.helperDisplayName,
    required this.helperUID,
    required this.helperEmail,
    required this.helperPhoneNumber,
    required this.helperPhotoURL,
    Key? key,
  }) : super(key: key);
  @override
  State<SoSReceivedBottomSheet> createState() => _PrivateSoSBottomSheetState();
}

class _PrivateSoSBottomSheetState extends State<SoSReceivedBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Container(
        color: Color.fromARGB(255, 176, 30, 19),
        height: 200,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(8),
                child: Text('Someone is helping you!',
                    style: TextStyle(
                      fontSize: 17,
                    ))),
            Flexible(
              flex: 1,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Flexible(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 20),
                          child: Column(children: <Widget>[
                            Flexible(
                                flex: 1,
                                child: Text(widget.helperDisplayName,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold))),
                            SizedBox(height: 5),
                            Flexible(flex: 1, child: Text(widget.helperEmail)),
                          ]),
                        )),
                    Flexible(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 20),
                          child: Column(children: <Widget>[
                            Flexible(
                                flex: 1,
                                child: Text('Distance',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold))),
                            SizedBox(height: 5),
                            Flexible(flex: 1, child: Text('5.0 km')),
                          ]),
                        )),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Flexible(
                        flex: 6,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 3, color: Colors.red),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  hintText:
                                      'Text to ${widget.helperDisplayName}',
                                  suffixIcon: Icon(Icons.phone_rounded,
                                      color: Colors.green),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 225, 76, 53))),
                        )),

                    // Expanded(
                    //     child: Row(children: <Widget>[
                    //   TextField(
                    //       decoration: InputDecoration(
                    //           filled: true,
                    //           fillColor: Color.fromARGB(255, 190, 210, 57))),
                    //   SizedBox(width: 5),
                    //   Text('icon')
                    // ]))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
