import 'package:test/test.dart';
import 'package:name_generator/models/name_builder.dart';

void main() {
  test('name_builder', () {
    final nameBuilder = new NameBuilder();
    Iterable<String> namePairs = ['a'];
    expect(namePairs.first, "a");
  });
}
