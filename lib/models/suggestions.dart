class Suggestions {
  List<String> _suggestions = [];

  add(String word) {
    _suggestions.add(word);
  }

  remove(String word) {
    _suggestions.remove(word);
  }
}
