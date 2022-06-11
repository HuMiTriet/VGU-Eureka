import 'dart:developer' as devtools show log;

import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/database/firestore/firestore.dart';
import 'package:etoet/services/database/firestore/firestore_emergency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main_view.dart';

const int maxLines = 3;
const int maxLength = 1000;
const List<String> emergencyType = [
  'Lost and Found',
  'Accident',
  'Thieves',
  'Other',
];

class SOSView extends StatefulWidget {
  const SOSView({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SOSViewState createState() => _SOSViewState();
}

class _SOSViewState extends State<SOSView> {
  TextEditingController locationDescriptionController = TextEditingController();
  TextEditingController situationDetailController = TextEditingController();

  bool isPublic = false;
  bool isFilled = false;
  bool lostAndFound = true;
  bool accident = true;
  bool thief = false;
  bool other = false;

  late AuthUser? user;

  @override
  Widget build(BuildContext context) {
    user = context.watch<AuthUser?>();

    locationDescriptionController.text =
        user?.emergency.locationDescription ?? '';
    situationDetailController.text = user?.emergency.situationDetail ?? '';
    return user?.emergency.isFilled == true
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainView()),
                      );
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
                child: CheckBoxList(
                  children: const [
                    'Lost and Found',
                    'Accident',
                    'Thieves',
                    'Other'
                  ],
                ),
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
              MultiSwitch(val: isPublic),
              const ProblemSolvedButton(),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainView()),
                      );
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
                child: CheckBoxList(
                  children: const [
                    'Lost and Found',
                    'Accident',
                    'Thieves',
                    'Other'
                  ],
                ),
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
                          user?.emergency.isFilled = true;
                          user?.emergency.isPublic = false;
                          user?.emergency.lostAndFound = lostAndFound;
                          user?.emergency.accident = accident;
                          user?.emergency.thief = thief;
                          user?.emergency.other = other;
                          user?.emergency.locationDescription =
                              locationDescriptionController.text;
                          user?.emergency.situationDetail =
                              situationDetailController.text;
                          FirestoreEmergency.setEmergencySignal(
                              uid: user!.uid,
                              lostAndFound: user!.emergency.lostAndFound,
                              accident: user!.emergency.accident,
                              thief: user!.emergency.thief,
                              other: user!.emergency.other,
                              isPublic: user!.emergency.isPublic,
                              isFilled: user!.emergency.isFilled,
                              locationDescription:
                                  locationDescriptionController.text,
                              situationDetail: situationDetailController.text);
                          Firestore.updateUserInfo(user!);
                          devtools.log(
                              'PRIVATE SIGNAL SENT FROM: ${user.toString()}',
                              name: 'EmergencySignal');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainView()),
                          );
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
                          user?.emergency.isFilled = true;
                          user?.emergency.isPublic = true;
                          user?.emergency.lostAndFound = lostAndFound;
                          user?.emergency.accident = accident;
                          user?.emergency.thief = thief;
                          user?.emergency.other = other;
                          user?.emergency.locationDescription =
                              locationDescriptionController.text;
                          user?.emergency.situationDetail =
                              situationDetailController.text;
                          FirestoreEmergency.setEmergencySignal(
                              uid: user!.uid,
                              lostAndFound: user!.emergency.lostAndFound,
                              accident: user!.emergency.accident,
                              thief: user!.emergency.thief,
                              other: user!.emergency.other,
                              isPublic: user!.emergency.isPublic,
                              isFilled: user!.emergency.isFilled,
                              locationDescription:
                                  locationDescriptionController.text,
                              situationDetail: situationDetailController.text);
                          Firestore.updateUserInfo(user!);
                          devtools.log(
                              'PUBLIC SIGNAL SENT FROM: ${user.toString()}',
                              name: 'EmergencySignal');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainView()),
                          );
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
          const Text('Detailed about your situation',
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class CheckBoxList extends StatefulWidget {
  CheckBoxList({
    super.key,
    required this.children,
  }) {
    values = List.generate(children.length, (index) => false);
  }
  final List<String> children;

  // final int count;
  late final List<bool> values;
  @override
  CheckBoxListState createState() => CheckBoxListState();
}

class CheckBoxListState extends State<CheckBoxList> {
  @override
  Widget build(BuildContext context) {
    var children = widget.children;
    var values = widget.values;
    return Column(
        children: children.map((element) {
      var index = children.indexOf(element);
      return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.teal,
        title: Text(
          element,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
        value: values[index],
        onChanged: (value) {
          setState(() {
            values[index] = value!;
          });
        },
      );
    }).toList());
  }
}

class MultiSwitch extends StatefulWidget {
  final bool val;

  const MultiSwitch({Key? key, required this.val}) : super(key: key);
  @override
  _MultiSwitchState createState() => _MultiSwitchState();
}

class _MultiSwitchState extends State<MultiSwitch> {
  late AuthUser user = context.watch<AuthUser>();

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
            FirestoreEmergency.clearEmergency(uid: user.uid);
            user.emergency.clearEmergency();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MainView()));
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [customeSwitch('PUBLIC SIGNAL', widget.val)],
      ),
    );
  }

  Widget customeSwitch(String text, bool val) {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          CupertinoSwitch(
              activeColor: Colors.red,
              trackColor: Colors.grey,
              value: val,
              onChanged: (value) async {
                if (value) {
                  setState(() {
                    showAlertDialog(context);
                  });
                } else {
                  setState(() {});
                }
              })
        ],
      ),
    );
  }
}

class ProblemSolvedButton extends StatelessWidget {
  const ProblemSolvedButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
        width: 280.0,
        height: 40.0,
        child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: Colors.green,
            elevation: 12.0,
            onPressed: () => solvedConfirmDialog(context),
            child: const Text(
              'MY SITUATION HAS BEEN SOLLVED!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: Colors.white,
              ),
            )),
      ),
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
            FirestoreEmergency.clearEmergency(
                uid: context.watch<AuthUser>().uid);
            context.watch<AuthUser>().emergency.clearEmergency();
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
}
