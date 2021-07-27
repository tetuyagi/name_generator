import 'package:flutter/material.dart';

import 'package:name_generator/models/constants.dart';

class SavedSuggestionsView extends StatefulWidget {
  final String titleName;
  SavedSuggestionsView({Key? key, required this.titleName}) : super(key: key);

  @override
  _SavedSuggestionsViewState createState() => _SavedSuggestionsViewState();
}

class _SavedSuggestionsViewState extends State<SavedSuggestionsView> {
  Set<String> _saved = Set<String>();

  @override
  Widget build(BuildContext context) {

      final Set<String> args = ModalRoute.of(context)!.settings.arguments as Set<String>;
      print("args = " + args.toString());
      _saved = args;



      final tiles = _saved.map((String word) {
        return ListTile(
            title: Text(
              word,
              style: biggerFont,
            ));
      });
      final divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text(widget.titleName),
        ),
        body: ListView(children: divided),
      );
    }

}
