// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main_view.dart';

class MySOSViewState extends StatelessWidget {
  const MySOSViewState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        MaterialPageRoute(builder: (context) => MainView()),
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
              MultiSwitch(),
              ProblemSolvedButton(),
            ],
          ),
        ),
      ),
    );
  }

  final int maxLines = 3;
  final int maxLength = 1000;

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
}

class _Buttons extends StatelessWidget {
  final Color color;
  final String text;

  const _Buttons({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints.tightForFinite(
            width: 300,
            height: 40,
          ),
          decoration: BoxDecoration(
            color: color,
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
                      text,
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
  @override
  _MultiSwitchState createState() => _MultiSwitchState();
}

class _MultiSwitchState extends State<MultiSwitch> {
  bool val1 = true;

  void toggleSwitch(bool value) {
    if (val1 == false) {
      setState(() {
        val1 = true;
      });
    } else {
      setState(() {
        val1 = false;
        showAlertDialog(context);
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
