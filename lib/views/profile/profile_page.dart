// ignore_for_file: prefer_const_constructors

import 'package:etoet/views/profile/Widgets/edit_image_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth/auth_user.dart';
import 'change_pass_page.dart';
import 'dart:developer';

class ProfilePage extends StatefulWidget {
  ProfilePage({
    Key? key,
    // requiredthis.user
  }) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();

  // final AuthUser user;

  final AuthUser user = AuthUser(
      phoneNumber: '1234',
      isEmailVerified: false,
      uid: '12352',
      email: 'mail@gmail.com',
      displayName: 'display name',
      photoURL: null);
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var mobileController = TextEditingController();
  var photoURL;

  late User user;

  @override
  void initState() {
    // TODO: implement initState

    user = FirebaseAuth.instance.currentUser!;

    FirebaseAuth.instance.userChanges().listen((event) {
      if (event != null && mounted) {
        setState(() {
          user = event;
        });
      }

      log(user.toString());
      nameController.text = user.displayName ?? '';
      emailController.text = user.email ?? '';
      mobileController.text = user.phoneNumber ?? '';
      photoURL = user.photoURL;

      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      // color: Colors.amber,
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 250.0,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              ),
                              iconSize: 18.0,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 20.0,
                              ),
                              child: Text('PROFILE',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      fontFamily: 'sans-serif-light',
                                      color: Colors.black)),
                            )
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Stack(fit: StackFit.loose, children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 140.0,
                                height: 140.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    // image: ExactAssetImage(widget.user.img),
                                    image: NetworkImage(user.photoURL ??
                                        'https://www.pavilionweb.com/wp-content/uploads/2017/03/man-300x300.png'),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ],
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.only(top: 90.0, right: 100.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    EditImageDialog(context);
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 25.0,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ]),
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Text(
                            'Personal Information',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          )),
                      ProfileFieldLabel(label: 'Name'),
                      ProfileField(
                          controller: nameController,
                          function: updateDisplayName),
                      ProfileFieldLabel(label: 'Email'),
                      ProfileField(
                        controller: emailController,
                        function: updateEmail,
                      ),
                      ProfileFieldLabel(label: 'Mobile'),
                      ProfileField(
                          controller: mobileController, function: updatePhone),
                      EditProfile(value: 'Change Password'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }

  void updateDisplayName(String name) {
    FirebaseAuth.instance.currentUser?.updateDisplayName(name);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('User name updated')));
  }

  void updatePhone(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (phoneAuthCredential) async {
        setState(() {});
        //signInWithPhoneAuthCredential(phoneAuthCredential);
      },
      verificationFailed: (verificationFailed) async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text('Please Enter Code'),
                  content: Text('Error with your phone'),
                  actions: []);
            });
        setState(() {});
      },
      codeSent: (verificationId, resendingToken) async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text('Please Enter Code'),
                  content: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter your username',
                    ),
                  ),
                  actions: []);
            });
        setState(() {});
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  void updateEmail(String email) {
    // FirebaseAuth.instance.currentUser
    //               ?.updateEmail(email);
  }
}

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key, required this.value}) : super(key: key);
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 14.0),
        child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0.0),
            ),
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Change_Pass_Page()),
              );
            }));
  }
}

class ProfileField extends StatelessWidget {
  ProfileField({Key? key, required this.controller, required this.function})
      : super(key: key);

  TextEditingController controller;
  Function function;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
        child: TextFormField(
            autofocus: false,
            controller: controller,
            decoration: InputDecoration(
                fillColor: Colors.amber,
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                )
                // border: OutlineInputBorder(
                //     borderRadius:
                //         BorderRadius.circular(32.0))
                ),
            enabled: true,
            onEditingComplete: () async {
              FocusScope.of(context).unfocus();
              function(controller.text);
            }));
  }
}

class ProfileFieldLabel extends StatelessWidget {
  String label;
  ProfileFieldLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: Text(
          label,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ));
  }
}
