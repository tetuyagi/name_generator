import 'dart:math';
import 'package:english_words/english_words.dart';

class NameBuilder {
  Iterable<String> buildWords(int count) {
    Iterable<WordPair> wordPairs = generateWordPairs().take(count);
    List<String> words = new List<String>();

    wordPairs.forEach((WordPair pair) {
      String word = pair.asPascalCase + Random().nextInt(10).toString();
      words.add(word);
    });

    return words;
  }
}
