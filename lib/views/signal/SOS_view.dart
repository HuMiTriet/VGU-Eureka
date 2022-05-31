import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/database/firestore.dart';
import 'package:etoet/services/map/geoflutterfire/geoflutterfire.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SOSView extends StatefulWidget {
  const SOSView({Key? key}) : super(key: key);

  @override
  State<SOSView> createState() => _SOSViewState();
}

class _SOSViewState extends State<SOSView> {
  AuthUser? authUser;
  late TextEditingController situationDetailTextController =
      TextEditingController();
  late TextEditingController locationDescriptionTextController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    authUser = context.watch<AuthUser?>();
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
                            color: Colors.red, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            ", your location will be public for all ETOET's users. This may put you in danger! Choose wisingly and intentinally"),
                  ])),
              const SizedBox(
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
          const Text(
              'Describe your location (trees, building, traffic signs or anything to find you faster)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          TextField(
            controller: locationDescriptionTextController,
            textInputAction: TextInputAction.newline,
            autofocus: true,
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
            controller: situationDetailTextController,
            textInputAction: TextInputAction.newline,
            autofocus: true,
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

  Widget buildButtons() => Row(
        children: [
          Expanded(
            child: _Buttons(
              color: Colors.green,
              text: 'PRIVATE SIGNAL',
              onTap: () {
                var situationDetail = situationDetailTextController.text;
                var locationDescription =
                    locationDescriptionTextController.text;
                Firestore.setEmergencySignal(
                    uid: authUser!.uid,
                    situationDetail: situationDetail,
                    locationDescription: locationDescription,
                    isPublic: false);
                Firestore.updateEmergencySignalLocation(
                    uid: authUser!.uid,
                    lat: authUser!.location.latitude,
                    lng: authUser!.location.longitude);
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: _Buttons(
              color: Colors.red,
              text: 'PUBLIC SIGNAL',
              onTap: () {
                var situationDetail = locationDescriptionTextController.text;
                var locationDescription = situationDetailTextController.text;
                Firestore.setEmergencySignal(
                    uid: authUser!.uid,
                    situationDetail: situationDetail,
                    locationDescription: locationDescription,
                    isPublic: true);
                GeoFlutterFire.updateEmergencySignalLocation(
                    uid: authUser!.uid,
                    lat: authUser!.location.latitude,
                    lng: authUser!.location.longitude);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      );
}

class _Buttons extends StatelessWidget {
  final Color color;
  final String text;
  final void Function() onTap;

  const _Buttons({
    required this.color,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: onTap,
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
