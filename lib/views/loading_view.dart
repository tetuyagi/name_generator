import 'package:flutter/material.dart';
import 'package:name_generator/models/constants.dart' as constants;

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text(constants.titleName)),
      body: Container(
        alignment: Alignment.center,
        child: Text("Loading"),
      ),
    ));
  }
}
