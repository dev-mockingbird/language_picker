import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/languages.dart';

void main() {
  test('Language constants', () {
    expect(Languages.korean.name, equals('Korean'));
    expect(Languages.french.isoCode, equals('fr'));
    expect(Languages.defaultLanguages.length, greaterThan(180));
  });

  test('Language from iso code', () {
    expect(Language.fromIsoCode('fr'), equals(Languages.french));
    expect(() => Language.fromIsoCode('xyz'), throwsStateError);
  });

  test('Language can be used as a Key in a Set or Map', () {
    final set = {Languages.japanese};
    expect(set, contains(Languages.japanese));
    final map = {Languages.japanese: 10};
    expect(map[Languages.japanese], 10);
  });
}
