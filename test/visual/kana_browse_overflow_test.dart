import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japan_learn/data/models/kana.dart';
import 'package:japan_learn/data/models/kana_progress.dart';
import 'package:japan_learn/features/kana/kana_browse_view.dart';
import 'package:japan_learn/theme/app_theme.dart';

import '../support/pump.dart';

void main() {
  setUpAll(disableGoogleFontsFetch);

  testWidgets('KanaBrowseView never overflows across phone widths', (tester) async {
    final kana = List<Kana>.generate(
      46,
      (i) => Kana(
        id: i + 1,
        character: 'あ',
        romaji: 'a',
        type: Kana.typeHiragana,
        rowGroup: 'a',
        orderIndex: i,
      ),
    );
    final progress = <int, KanaProgress>{
      for (final k in kana.take(10))
        k.id!: KanaProgress.initial(
          kanaId: k.id!,
          now: DateTime.utc(2026, 1, 1),
        ),
    };

    await expectNoOverflowAcrossViewports(tester, () async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildAppTheme(),
          home: Scaffold(
            body: KanaBrowseView(kana: kana, progress: progress),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
    });
  });
}
