import 'package:etoet/constants/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import '../main_view.dart';

enum SosScreenState { SHOW_SOS_FORM, SHOW_USER_SIGNAL }

const int maxLines = 3;
const int maxLength = 1000;

class SOSView extends StatefulWidget {
  const SOSView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SOSViewState createState() => _SOSViewState();
}

class _SOSViewState extends State<SOSView> {
  SosScreenState currentState = SosScreenState.SHOW_SOS_FORM;

  bool showLoading = false;
  bool privateSignal = false;
  bool publicSignal = false;

  @override
  Widget build(BuildContext context) {
    return showLoading
        ? const Scaffold(
            body: SafeArea(
                child: Center(
              child: CircularProgressIndicator(),
            )),
          )
        : currentState == SosScreenState.SHOW_SOS_FORM
            ? showSOSFormView(context)
            : showUserFormView(context);
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
                child: Center(child: buildSituationField()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: buildTextDescriptionField()),
              ),
              MultiSwitch(val: privateSignal),
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
                child: Center(child: buildSituationField()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: buildTextDescriptionField()),
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
                    child: Buttons(
                      currentState: currentState,
                      check: privateSignal,
                      color: Colors.green,
                      text: 'PRIVATE SIGNAL',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Buttons(
                      currentState: currentState,
                      check: publicSignal,
                      color: Colors.red,
                      text: 'PUBLIC SIGNAL',
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

  Widget buildTextDescriptionField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'Describe your location (trees, building, traffic signs or anything to find you faster)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          TextField(
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

  Widget buildSituationField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Detailed about your situation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          TextField(
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

class Buttons extends StatefulWidget {
  final Color color;
  final String text;
  bool check;
  SosScreenState currentState;

  Buttons(
      {Key? key,
      required this.color,
      required this.text,
      required this.check,
      required this.currentState})
      : super(key: key);

  @override
  _ButtonsState createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: () {
          widget.check = !widget.check;
          devtools.log('Check: ${widget.check}', name: 'Buttons');
          setState(() {
            widget.currentState = SosScreenState.SHOW_USER_SIGNAL;
            devtools.log('Current state: ${widget.currentState}',
                name: 'Buttons');
          });
          Navigator.of(context).pushNamed(mainRoute);
        },
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints.tightForFinite(
            width: 300,
            height: 40,
          ),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const SizedBox(width: 5),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.text,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckBoxList extends StatefulWidget {
  CheckBoxList({super.key, required this.children}) {
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
  bool val1 = false;
  void toggleSwitch(bool value) {
    if (widget.val) {
      setState(() {
        val1 = true;
        showAlertDialog(context);
      });
    } else {
      setState(() {
        val1 = false;
      });
    }
  }

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
          onPressed: () {},
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
        children: [customeSwitch('PUBLIC SIGNAL', val1)],
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
            onChanged: toggleSwitch,
          )
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
          onPressed: () {},
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
