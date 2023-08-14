import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';

void main() {
  testWidgets('LanguagePickerDropdown uses the default list of languages',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LanguagePickerDropdown())));
    expect(find.textContaining('Armenian'), findsOneWidget);
    expect(find.textContaining('Japanese'), findsOneWidget);
    expect(find.textContaining('Turkish'), findsOneWidget);
  });

  testWidgets(
      'Renders only the selected languages and lets the user select a language',
      (WidgetTester tester) async {
    final streamController = StreamController<Language>();
    final picker = LanguagePickerDropdown(
      onValuePicked: (selectedLanguage) {
        streamController.add(selectedLanguage);
      },
      languages: [Languages.english, Languages.french],
    );
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: picker)));
    await tester.tap(find.byType(LanguagePickerDropdown));
    await tester.pump(Duration(seconds: 1));
    await tester.pump();

    expect(find.textContaining('Japanese'), findsNothing);

    // As per https://stackoverflow.com/a/64496868, once the menu is open, there
    // there are two widgets, and we should tap the latter one.
    expect(find.textContaining('French'), findsNWidgets(2));
    await tester.tap(find.textContaining('French', skipOffstage: false).last);
    expect(streamController.stream, emits(Languages.french));
    streamController.close();
  });

  testWidgets('initial language', (WidgetTester tester) async {
    final picker = LanguagePickerDropdown(
      languages: [Languages.english, Languages.french, Languages.norwegian],
      initialValue: Languages.french,
    );
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: picker)));
    expect(find.textContaining('French'), findsOneWidget);
    // Somehow French is pre-selected but English exists in the tree.
    expect(find.textContaining('English'), findsOneWidget);
  });

  testWidgets('item builder', (WidgetTester tester) async {
    final picker = LanguagePickerDropdown(
      languages: [Languages.english, Languages.french],
      // Render only the iso code, not the name.
      itemBuilder: (language) => Text(language.isoCode),
    );
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: picker)));
    // Check that it rendered the iso code, but not the name.
    expect(find.text('fr'), findsOneWidget);
    expect(find.text('French'), findsNothing);
  });
}
