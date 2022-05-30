// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class SOSView extends StatefulWidget {
  SOSView({Key? key}) : super(key: key);

  @override
  State<SOSView> createState() => _SOSViewState();
}

class _SOSViewState extends State<SOSView> {
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
                  Text(
                    'EMERGENCY!',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.close),
                    color: Colors.white,
                  ),
                ],
              ),
              Text(
                'What kind of problem you need to help with?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: CheckBoxList(
                  children: ['Lost and Found', 'Accident', 'Thieves', 'Other'],
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
                  text: TextSpan(
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
                            color: Colors.red, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            ", your location will be public for all ETOET's users. This may put you in danger! Choose wisingly and intentinally"),
                  ])),
              SizedBox(
                height: 15,
              ),
              buildButtons()
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
          Text(
              'Describe your location (trees, building, traffic signs or anything to find you faster)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          TextField(
            textInputAction: TextInputAction.newline,
            autofocus: true,
            maxLength: maxLength,
            maxLines: maxLines,
            style: TextStyle(fontSize: 20),
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
          Text('Detailed about your situation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          TextField(
            textInputAction: TextInputAction.newline,
            autofocus: true,
            maxLength: maxLength,
            maxLines: maxLines,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: border(),
            ),
          ),
        ],
      );

  InputBorder border() => OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        borderSide: BorderSide(color: Colors.black, width: 0.5),
      );

  Widget buildButtons() => Row(
        children: [
          Expanded(
            child: _Buttons(
              color: Colors.green,
              text: 'PRIVATE SIGNAL',
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: _Buttons(
              color: Colors.red,
              text: 'PUBLIC SIGNAL',
            ),
          ),
        ],
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
                      style: TextStyle(color: Colors.white, fontSize: 10),
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
  CheckBoxList({required this.children}) {
    this.values = List.generate(children.length, (index) => false);
  }
  final List<String> children;
  // final int count;
  late final List<bool> values;
  @override
  _CheckBoxListState createState() => _CheckBoxListState();
}

class _CheckBoxListState extends State<CheckBoxList> {
  @override
  Widget build(BuildContext context) {
    var children = widget.children;
    var values = widget.values;
    return Column(
        children: children.map((element) {
      int index = children.indexOf(element);
      return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.teal,
        title: Text(
          element,
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
        value: values[index],
        onChanged: (bool? value) {
          setState(() {
            values[index] = value!;
          });
        },
      );
    }).toList());
  }
}
