import 'package:flutter/material.dart';

import 'change_pass_page.dart';
// import 'package:flutter/cupertino.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var mobileController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = 'User Name';
    emailController.text = 'mail@gmail.com';
    mobileController.text = '12345677';
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
          body: Container(
        color: Colors.amber,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 250.0,
                  color: Colors.amber,
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
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      // image: ExactAssetImage(widget.user.img),
                                      image: NetworkImage(
                                          'https://www.pavilionweb.com/wp-content/uploads/2017/03/man-300x300.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 90.0, right: 100.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 25.0,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
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
                        ProfileField(controller: nameController),
                        ProfileFieldLabel(label: 'Email'),
                        ProfileField(controller: emailController),
                        ProfileFieldLabel(label: 'Mobile'),
                        ProfileField(controller: mobileController),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 14.0),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(0.0),
                                ),
                                child: const Text(
                                  'Change Password',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Change_Pass_Page()),
                                  );
                                })),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class ProfileField extends StatelessWidget {
  ProfileField({Key? key, required this.controller}) : super(key: key);

  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
        child: TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
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
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              }),
          onPressed: () {},
        ));
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
