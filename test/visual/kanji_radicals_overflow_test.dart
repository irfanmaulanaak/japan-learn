import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japan_learn/data/models/kanji.dart';
import 'package:japan_learn/features/kanji/kanji_radicals_view.dart';
import 'package:japan_learn/theme/app_theme.dart';

import '../support/pump.dart';

void main() {
  setUpAll(disableGoogleFontsFetch);

  testWidgets('KanjiRadicalsView never overflows across phone widths',
      (tester) async {
    final kanji = List<Kanji>.generate(
      40,
      (i) => Kanji(
        id: i + 1,
        character: '聞',
        meaning: 'very long meaning string that should ellipsize fine',
        onyomi: 'ブン',
        kunyomi: 'き-',
        radicals: '門,耳',
        strokes: 14,
        level: 'N5',
      ),
    );
    await expectNoOverflowAcrossViewports(tester, () async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildAppTheme(),
          home: Scaffold(body: KanjiRadicalsView(kanji: kanji)),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
    });
  });
}
