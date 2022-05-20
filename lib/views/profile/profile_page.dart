import 'package:etoet/views/profile/Widgets/edit_image_dialog.dart';
import 'package:flutter/material.dart';
import '../../services/auth/auth_user.dart';
import 'change_pass_page.dart';

// import 'package:flutter/cupertino.dart';

class ProfilePage extends StatefulWidget {
  final AuthUser user;

  const ProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();

  // final AuthUser user;

}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.displayName ?? '';
    emailController.text = widget.user.email ?? '';
    mobileController.text = widget.user.phoneNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
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
                                  image: DecorationImage(
                                    // image: ExactAssetImage(widget.user.img),
                                    image: NetworkImage(widget.user.photoURL ??
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
                          )),
                      const ProfileFieldLabel(label: 'Name'),
                      ProfileField(controller: nameController),
                      const ProfileFieldLabel(label: 'Email'),
                      ProfileField(controller: emailController),
                      const ProfileFieldLabel(label: 'Mobile'),
                      ProfileField(controller: mobileController),
                      const EditProfile(value: 'Change Password'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      )),
    );
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
              style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Change_Pass_Page()),
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
        ));
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
