import 'package:flutter/material.dart';

class EmergencyDefaultMap extends StatefulWidget {
  final void Function() toEmergencyState;
  final void Function() toDefaultState;

  const EmergencyDefaultMap({
    Key? key,
    required this.toEmergencyState,
    required this.toDefaultState,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmergencyDefaultMapState();
}

class _EmergencyDefaultMapState extends State<EmergencyDefaultMap> {
  bool isSOS = false;
  String mapToggleButtonText = 'SOS MAP';

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: isSOS ? const Color(0x88E7740A) : const Color(0x88E70A0A),
        onPrimary: Colors.white,
        onSurface: Colors.transparent,
        enableFeedback: false,
      ),
      child: Text(mapToggleButtonText),
      onPressed: () {
        if (!isSOS) {
          isSOS = !isSOS;
          mapToggleButtonText = 'DEFAULT MAP';
          widget.toEmergencyState();
        } else {
          isSOS = !isSOS;
          mapToggleButtonText = 'SOS MAP';
          widget.toDefaultState();
        }
      },
    );
  }
}
