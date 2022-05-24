import 'package:etoet/views/profile/Widgets/edit_image_dialog.dart';
import 'package:etoet/views/profile/change_email_page.dart';
import 'package:etoet/views/profile/verification_view.dart';
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth/auth_user.dart';
import 'change_pass_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  String? photoURL;

  late AuthUser? user;

  @override
  Widget build(BuildContext context) {
    user = context.watch<AuthUser?>();

    nameController.text = user!.displayName ?? '';
    emailController.text = user!.email ?? '';
    mobileController.text = user!.phoneNumber ?? '';
    photoURL = user!.photoURL;

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 250.0,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 20.0),
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
                        padding: const EdgeInsets.only(top: 20.0),
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
                                    border: Border.all(width: 3),
                                    // image: ExactAssetImage(widget.user.img),
                                    image: DecorationImage(
                                      image: NetworkImage(user!.photoURL ??
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
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      EditImageDialog(context, user!);
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
                    padding: const EdgeInsets.only(bottom: 25.0),
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
                          ),
                        ),
                        const ProfileFieldLabel(label: 'Display Name'),
                        ProfileField(controller: nameController),
                        const ProfileFieldLabel(label: 'Email'),
                        ProfileField(controller: emailController),
                        EditVerifiableFieldsController(
                          value: 'Change Email',
                          user: user!,
                        ),
                        const ProfileFieldLabel(label: 'Mobile'),
                        ProfileField(controller: mobileController),
                        EditVerifiableFieldsController(
                          value: 'Change Password',
                          user: user!,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Class to handle Fields that required verification in order to confirm the
///changes
///
/// Since the changes must be verified, upon pressing the button the class
/// will push a new screen on top
class EditVerifiableFieldsController extends StatelessWidget {
  late VerificationView verificationView;
  AuthUser user;

  final String value;

  EditVerifiableFieldsController({
    Key? key,
    required this.value,
    required this.user,
  }) : super(key: key) {
    switch (value) {
      case 'Change Password':
        verificationView = ChangePassPage(
          user: user,
          title: value,
        );
        break;
      case 'Change Email':
        verificationView = ChangeEmailPage(
          user: user,
          title: value,
        );
        break;
      /* case 'Change Phone Number': */
      /*   verificationView = ChangePhoneNumberPage( */
      /*     user: user, */
      /*     title: value, */
      /*   ); */
      /*   break; */
      default:
    }
  }

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
              style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => verificationView),
              );
            }));
  }
}

class ProfileField extends StatelessWidget {
  const ProfileField({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: TextFormField(
            autofocus: false,
            controller: controller,
            decoration: const InputDecoration(
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
      ),
    );
  }
}

class ProfileFieldLabel extends StatelessWidget {
  final String label;
  const ProfileFieldLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ));
  }
}