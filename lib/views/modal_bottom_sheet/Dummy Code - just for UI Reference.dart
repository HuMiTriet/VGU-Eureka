import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';

class FvColors {
  static const Color screen1Background = Color.fromARGB(0,0,0,0);
  static const Color container2Background = Color.fromARGB(255,199,9,9);
  static const Color imageview3Background = Color.fromARGB(255,255,255,255);
  static const Color textview4FontColor = Color.fromARGB(255,0,0,0);
  static const Color button6Background = Color.fromARGB(255,132,2,2);
}

class Confirmbox extends StatefulWidget {
  @override
  _ConfirmboxState createState() => _ConfirmboxState();
}

class _ConfirmboxState extends State<Confirmbox> {
  @override
  Widget build(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: FvColors.screen1Background,
      body:
      SizedBox.expand(
        // width: width,
        // height: height,
        child:
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children:[
// Component Roundedrectangle_Container_2
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 272,
                decoration: BoxDecoration(
                  color: Color(0xffc70909),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),

// End Roundedrectangle_Container_2
// Component kmawayfromyou_TextView_5
            Positioned(
                left: 110,
                top: 7,
                child:
                Container(
                    height: 19,
                    width: 141,
                    child: Text(
                      "0.5 km away from you",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,

                          color: FvColors.imageview3Background,
                          wordSpacing: 1.0),
                    ))),
// End kmawayfromyou_TextView_5
// Component Group_ImageView_3
            Positioned(
              left: 11,
              top: 43,
              child: Container(
                width: 339,
                height: 146,
                child: Image.asset("assets/Group_ImageView_3-339x146.png"),
              ),
            ),
// End Group_ImageView_3
// Component spidermangmailcom_TextView_4
            Positioned(
                left: 56,
                top: 69,
                child:
                Container(
                    height: 12,
                    width: 122,
                    child: Text(
                      "spiderman@gmail.com",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,

                          color: FvColors.textview4FontColor,
                          wordSpacing: 1.0),
                    ))),
// End spidermangmailcom_TextView_4
// Component Group_Button_6
            Positioned(
                left: 61,
                top: 207,
                child: Container(
                    width: 239,
                    height: 39,
                    child: TextButton(
                      child: Text('Confirm help spider_man',
                          style: const TextStyle(
                            fontSize: 30,
                            color: FvColors.imageview3Background,
                            fontWeight: FontWeight.w700,
                          )),
                      style: TextButton.styleFrom(
                        backgroundColor: FvColors.button6Background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                          side: BorderSide(
                            width: 0,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      onPressed: () {
                      },
                    ))),
// End Group_Button_6
          ],
        ),
      ),
    );
  }
}
        