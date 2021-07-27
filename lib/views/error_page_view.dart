import 'package:flutter/material.dart';
import 'package:name_generator/models/constants.dart' as constants;

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text(constants.titleName)),
      body: Container(
        alignment: Alignment.center,
        child: Text("Error"),
      ),
    ));
  }
}
