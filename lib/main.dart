import 'package:flutter/material.dart';
import 'package:name_generator/models/name_builder.dart';

const String titleName = "My Name Generator";
const num fontSize = 18.0;
const int generateNumber = 10;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: titleName,
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <String>[];
  final _biggerFont = TextStyle(fontSize: fontSize);
  final _builder = NameBuilder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleName),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(_builder.buildWords(generateNumber));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(String word) {
    return ListTile(
        title: Text(
      word,
      style: _biggerFont,
    ));
  }
}
