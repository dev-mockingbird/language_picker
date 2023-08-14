@Skip('''Font rendering is different on GitHub and my machine, leading to
failures on GitHub. Screenshot tests fail with less than a percent in pixel
difference. I'll disable the tests for now.''')
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/language_picker_dropdown_controller.dart';
import 'package:language_picker/languages.dart';

main() {
  testWidgets('controller', (WidgetTester tester) async {
    // Needed to render text instead of boxes. See https://api.flutter.dev/flutter/flutter_test/GoldenFileComparator-class.html#including-fonts.
    final font = rootBundle.load('assets/fonts/Roboto/Roboto-Regular.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(font);
    await fontLoader.load();

    // `initialValue` actually takes precedence over the controller.
    final controller = LanguagePickerDropdownController(Languages.english);

    final picker = LanguagePickerDropdown(
      controller: controller,
      languages: [Languages.english, Languages.french, Languages.norwegian],
      initialValue: Languages.french,
    );
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: picker)));

    await expectLater(find.byType(LanguagePickerDropdown),
        matchesGoldenFile('goldens/controller_1.png'));

    controller.value = Languages.norwegian;
    await tester.pump();
    await expectLater(find.byType(LanguagePickerDropdown),
        matchesGoldenFile('goldens/controller_2.png'));
  });
}
