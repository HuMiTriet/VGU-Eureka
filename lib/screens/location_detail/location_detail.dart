import 'package:flutter/material.dart';
import 'package:todo/screens/location_detail/text_section.dart';

class LocationDetail extends StatelessWidget {
  const LocationDetail(Key? key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('xin chào'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          TextSection(Colors.black),
          TextSection(Colors.red),
          TextSection(Colors.yellow),
        ],
      ),
    );
  }
}
