import 'dart:math';
// ignore: import_of_legacy_library_into_null_safe
import 'package:english_words/english_words.dart';

class NameBuilder {
  Iterable<String> buildWords(int count) {
    Iterable<WordPair> wordPairs = generateWordPairs().take(count);
    List<String> words = [];

    wordPairs.forEach((WordPair pair) {
      String word = pair.asPascalCase + Random().nextInt(10).toString();
      words.add(word);
    });

    return words;
  }
}
