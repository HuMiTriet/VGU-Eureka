import 'dart:developer' as devtools show log;

import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/database/firestore/firestore_emergency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const int maxLines = 3;
const int maxLength = 1000;

class SOSView extends StatefulWidget {
  const SOSView({
    Key? key,
    required this.uid,
  }) : super(key: key);
  final String uid;
  @override
  // ignore: library_private_types_in_public_api
  _SOSViewState createState() => _SOSViewState();
}

class _SOSViewState extends State<SOSView> {
  late TextEditingController locationDescriptionController;
  late TextEditingController situationDetailController;

  late bool isPublic;
  late bool isFilled;
  late bool lostAndFound;
  late bool accident;
  late bool thief;
  late bool other;
  late AuthUser? user;

  late String photoURL;

  bool showLoading = true;

  @override
  Widget build(BuildContext context) {
    user = context.watch<AuthUser?>();

    return showLoading
        ? const Scaffold(
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : ((lostAndFound || accident || thief || other) &&
                locationDescriptionController.text.isNotEmpty &&
                situationDetailController.text.isNotEmpty)
            ? showUserFormView(context)
            : showSOSFormView(context);
  }

  Widget showUserFormView(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 172, 172, 2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'EMERGENCY!',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        FirestoreEmergency.setEmergencySignal(
                            helpStatus: 'notHelp',
                            uid: user!.uid,
                            emergencyType: lostAndFound
                                ? 'lostAndFound'
                                : accident
                                    ? 'accident'
                                    : thief
                                        ? 'thief'
                                        : other
                                            ? 'other'
                                            : '',
                            isPublic: isPublic,
                            locationDescription:
                                locationDescriptionController.text,
                            situationDetail: situationDetailController.text,
                            lat: user!.location.latitude,
                            lng: user!.location.longitude,
                            displayName: user!.displayName ?? 'Etoet user',
                            photoUrl: user!.photoURL ??
                                'https://firebasestorage.googleapis.com/v0/b/etoet-pe2022.appspot.com/o/images%2FDefault.png?alt=media&token=9d2d4b15-cf04-44f1-b46d-ab0f06ab2977');
                      });
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                  ),
                ],
              ),
              const Text(
                'What kind of problem you need to help with?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: Column(children: [
                  // Lost and Found box
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.teal,
                    title: const Text(
                      'Lost and Found',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    value: lostAndFound,
                    onChanged: (value) {
                      if (value!) {
                        setState(() {
                          lostAndFound = value;
                          accident = false;
                          thief = false;
                          other = false;
                        });
                      } else {
                        setState(() {
                          lostAndFound = value;
                        });
                      }
                    },
                  ),
                  // Accident box
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.teal,
                    title: const Text(
                      'Accident',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    value: accident,
                    onChanged: (value) {
                      if (value!) {
                        setState(() {
                          lostAndFound = false;
                          accident = value;
                          thief = false;
                          other = false;
                        });
                      } else {
                        setState(() {
                          accident = value;
                        });
                      }
                    },
                  ),
                  // Thief box
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.teal,
                    title: const Text(
                      'Thieves',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    value: thief,
                    onChanged: (value) {
                      if (value!) {
                        setState(() {
                          lostAndFound = false;
                          accident = false;
                          thief = value;
                          other = false;
                        });
                      } else {
                        setState(() {
                          thief = value;
                        });
                      }
                    },
                  ),
                  // Other box
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.teal,
                    title: const Text(
                      'Other',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    value: other,
                    onChanged: (value) {
                      if (value!) {
                        setState(() {
                          lostAndFound = false;
                          accident = false;
                          thief = false;
                          other = value;
                        });
                      } else {
                        setState(() {
                          other = value;
                        });
                      }
                    },
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: buildSituationField(situationDetailController)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: buildTextDescriptionField(
                        locationDescriptionController)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 22.0, left: 16.0, right: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'PUBLIC SIGNAL',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          CupertinoSwitch(
                              activeColor: Colors.red,
                              trackColor: Colors.grey,
                              value: isPublic,
                              onChanged: (value) async {
                                if (value) {
                                  setState(() {
                                    isPublic = value;
                                    FirestoreEmergency.setEmergencySignal(
                                        helpStatus: 'helperVacant ',
                                        //phoneNumber: user!.phoneNumber,
                                        uid: user!.uid,
                                        emergencyType: lostAndFound
                                            ? 'lostAndFound'
                                            : accident
                                                ? 'accident'
                                                : thief
                                                    ? 'thief'
                                                    : other
                                                        ? 'other'
                                                        : '',
                                        isPublic: isPublic,
                                        locationDescription:
                                            locationDescriptionController.text,
                                        situationDetail:
                                            situationDetailController.text,
                                        lat: user!.location.latitude,
                                        lng: user!.location.longitude,
                                        displayName:
                                            user!.displayName ?? 'Etoet user',
                                        photoUrl: user!.photoURL ??
                                            'https://firebasestorage.googleapis.com/v0/b/etoet-pe2022.appspot.com/o/images%2FDefault.png?alt=media&token=9d2d4b15-cf04-44f1-b46d-ab0f06ab2977');
                                  });
                                  devtools.log('Update to public signal',
                                      name: 'EmergencySignal');
                                  successPublicSignalDialog(context);
                                } else {
                                  showAlertDialog(context);
                                }
                              })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                  width: 280.0,
                  height: 40.0,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.green,
                      elevation: 12.0,
                      onPressed: () => {
                            solvedConfirmDialog(context),
                          },
                      child: const Text(
                        'MY SITUATION HAS BEEN SOLVED!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showSOSFormView(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 172, 172, 2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'EMERGENCY!',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                  ),
                ],
              ),
              const Text(
                'What kind of problem you need to help with?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: Column(children: [
                  // Lost and Found box
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.teal,
                    title: const Text(
                      'Lost and Found',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    value: lostAndFound,
                    onChanged: (value) {
                      if (value!) {
                        setState(() {
                          lostAndFound = value;
                          accident = false;
                          thief = false;
                          other = false;
                        });
                      } else {
                        setState(() {
                          lostAndFound = value;
                        });
                      }
                    },
                  ),
                  // Accident box
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.teal,
                    title: const Text(
                      'Accident',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    value: accident,
                    onChanged: (value) {
                      if (value!) {
                        setState(() {
                          lostAndFound = false;
                          accident = value;
                          thief = false;
                          other = false;
                        });
                      } else {
                        setState(() {
                          accident = value;
                        });
                      }
                    },
                  ),
                  // Thief box
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.teal,
                    title: const Text(
                      'Thieves',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    value: thief,
                    onChanged: (value) {
                      if (value!) {
                        setState(() {
                          lostAndFound = false;
                          accident = false;
                          thief = value;
                          other = false;
                        });
                      } else {
                        setState(() {
                          thief = value;
                        });
                      }
                    },
                  ),
                  // Other box
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.teal,
                    title: const Text(
                      'Other',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    value: other,
                    onChanged: (value) {
                      if (value!) {
                        setState(() {
                          lostAndFound = false;
                          accident = false;
                          thief = false;
                          other = value;
                        });
                      } else {
                        setState(() {
                          other = value;
                        });
                      }
                    },
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: buildSituationField(situationDetailController)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: buildTextDescriptionField(
                        locationDescriptionController)),
              ),
              RichText(
                  text: const TextSpan(
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                    TextSpan(
                        text: 'WARNING: ',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        )),
                    TextSpan(text: 'When you choose'),
                    TextSpan(
                      text: ' PUBLIC SIGNAL',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            ", your location will be public for all ETOET's users. This may put you in danger! Choose wisingly and intentinally"),
                  ])),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            FirestoreEmergency.setEmergencySignal(
                                helpStatus: 'helperVacant ',
                                //phoneNumber: user!.phoneNumber,
                                uid: user!.uid,
                                emergencyType: lostAndFound
                                    ? 'lostAndFound'
                                    : accident
                                        ? 'accident'
                                        : thief
                                            ? 'thief'
                                            : other
                                                ? 'other'
                                                : '',
                                isPublic: isPublic,
                                locationDescription:
                                    locationDescriptionController.text,
                                situationDetail: situationDetailController.text,
                                lat: user!.location.latitude,
                                lng: user!.location.longitude,
                                displayName: user!.displayName ?? 'Etoet user',
                                photoUrl: user!.photoURL ??
                                    'https://firebasestorage.googleapis.com/v0/b/etoet-pe2022.appspot.com/o/images%2FDefault.png?alt=media&token=9d2d4b15-cf04-44f1-b46d-ab0f06ab2977');
                            showSignalPostedDialog(context, 'private');
                          });
                          devtools.log('PRIVATE SIGNAL SENT FROM: ${user!.uid}',
                              name: 'EmergencySignal');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          constraints: const BoxConstraints.tightForFinite(
                            width: 300,
                            height: 40,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              const SizedBox(width: 5),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'PRIVATE SIGNAL',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                    SizedBox(width: 15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPublic = true;
                            FirestoreEmergency.setEmergencySignal(
                                helpStatus: 'helperVacant ',
                                //phoneNumber: user!.phoneNumber,
                                uid: user!.uid,
                                emergencyType: lostAndFound
                                    ? 'lostAndFound'
                                    : accident
                                        ? 'accident'
                                        : thief
                                            ? 'thief'
                                            : other
                                                ? 'other'
                                                : '',
                                isPublic: isPublic,
                                locationDescription:
                                    locationDescriptionController.text,
                                situationDetail: situationDetailController.text,
                                lat: user!.location.latitude,
                                lng: user!.location.longitude,
                                photoUrl: user!.photoURL ??
                                    'https://firebasestorage.googleapis.com/v0/b/etoet-pe2022.appspot.com/o/images%2FDefault.png?alt=media&token=9d2d4b15-cf04-44f1-b46d-ab0f06ab2977',
                                displayName: user!.displayName ?? 'Etoet user');
                            showSignalPostedDialog(context, 'public');
                          });
                          devtools.log('PUBLIC SIGNAL SENT FROM: ${user!.uid}',
                              name: 'EmergencySignal');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          constraints: const BoxConstraints.tightForFinite(
                            width: 300,
                            height: 40,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              const SizedBox(width: 5),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'PUBLIC SIGNAL',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                    SizedBox(width: 15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextDescriptionField(TextEditingController controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'Describe your location (trees, building, traffic signs or anything to find you faster)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          TextField(
            controller: controller,
            textInputAction: TextInputAction.newline,
            autofocus: false,
            maxLength: maxLength,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: border(),
            ),
          ),
        ],
      );

  Widget buildSituationField(TextEditingController controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Details about your situation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          TextField(
            controller: controller,
            textInputAction: TextInputAction.newline,
            autofocus: false,
            maxLength: maxLength,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: border(),
            ),
          ),
        ],
      );

  InputBorder border() => const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        borderSide: BorderSide(color: Colors.black, width: 0.5),
      );

  void showAlertDialog(BuildContext context) {
    // set up the button
    var alertDialog = AlertDialog(
      title: const Text(
        'OOPS?',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        'Your signal is public now and you can not change it back into private.\n '
        '\n Do you  want to keep your signal?',
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
            onPrimary: Colors.white,
          ),
          onPressed: () {
            setState(() {
              lostAndFound = false;
              accident = false;
              thief = false;
              other = false;
              isPublic = false;
              locationDescriptionController.text = '';
              situationDetailController.text = '';
              FirestoreEmergency.clearEmergency(uid: user!.uid);
              user!.emergency.clearEmergency();
            });
            Navigator.pop(context);
          },
          child: const Text('DELETE THIS SIGNAL'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            onPrimary: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('KEEP IT AS PUBLIC SIGNAL'),
        )
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }

  void solvedConfirmDialog(BuildContext context) {
    var alertDialog = AlertDialog(
      title: const Text(
        'Are you sure?',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        'Confirm that your situation has been solved will disable your signal and others can not find you\n '
        '\n Do you still want to confirm?',
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            onPrimary: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('NO, KEEP MY SIGNAL ON'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
          ),
          onPressed: () {
            setState(() {
              lostAndFound = false;
              accident = false;
              thief = false;
              other = false;
              isPublic = false;
              locationDescriptionController.text = '';
              situationDetailController.text = '';
              FirestoreEmergency.clearEmergency(uid: user!.uid);
              user!.emergency.clearEmergency();
            });
            Navigator.pop(context);
          },
          child: const Text('CONFIRM'),
        )
      ],
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => alertDialog);
  }

  void successPublicSignalDialog(BuildContext context) {
    var alertDialog = AlertDialog(
      title: const Text(
        'Your signal has been changed!',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        'Your signal is public now\n '
        '\nYou can now navigate to main view',
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('BACK TO SOS SCREEN'),
        )
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }

  void showSignalPostedDialog(BuildContext context, String type) {
    var alertDialog = AlertDialog(
      title: Text(
        'Your $type signal has been posted!',
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        'Be patient! You will get help soon. Until then, make sure that you are safe\n'
        '\nWish you all the best!',
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('BACK TO SOS SCREEN'),
        )
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }

  @override
  void initState() {
    locationDescriptionController = TextEditingController();
    situationDetailController = TextEditingController();
    FirestoreEmergency.getEmergencySignal(uid: widget.uid)
        .then((value) => {
              isFilled = value.situationDetail != '' &&
                  value.locationDescription != '' &&
                  value.emergencyType != '',
              isPublic = value.isPublic,
              lostAndFound = value.emergencyType == 'lostAndFound',
              accident = value.emergencyType == 'accident',
              thief = value.emergencyType == 'thief',
              other = value.emergencyType == 'other',
              situationDetailController.text = value.situationDetail,
              locationDescriptionController.text = value.locationDescription,
              devtools.log(value.toString())
            })
        .whenComplete(
          () => {
            setState(() => {
                  showLoading = false,
                }),
          },
        );
    super.initState();
  }

  @override
  void dispose() {
    locationDescriptionController.dispose();
    situationDetailController.dispose();
    super.dispose();
  }
}
