import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japan_learn/data/models/kana.dart';
import 'package:japan_learn/data/models/user_goal.dart';
import 'package:japan_learn/features/anki/anki_import_screen.dart';
import 'package:japan_learn/features/dictionary/dictionary_screen.dart';
import 'package:japan_learn/features/home/home_screen.dart';
import 'package:japan_learn/features/jlpt_mock/jlpt_mock_screen.dart';
import 'package:japan_learn/features/kana/kana_module_screen.dart';
import 'package:japan_learn/features/kanji/kanji_screen.dart';
import 'package:japan_learn/features/learn/learn_screen.dart';
import 'package:japan_learn/features/onboarding/onboarding_screen.dart';
import 'package:japan_learn/features/profile/profile_screen.dart';
import 'package:japan_learn/features/reading/reading_screen.dart';
import 'package:japan_learn/features/review/review_hub_screen.dart';
import 'package:japan_learn/features/shadowing/shadowing_screen.dart';
import 'package:japan_learn/features/vocabulary/vocabulary_screen.dart';

import '../support/pump.dart';

void main() {
  setUpAll(disableGoogleFontsFetch);

  Future<void> verify(
    WidgetTester tester,
    Widget Function() build, {
    TestFakes Function()? makeFakes,
  }) async {
    await expectNoOverflowAcrossViewports(tester, () async {
      await pumpScreen(tester, build(), fakes: makeFakes?.call());
    });
  }

  TestFakes withGoal() => TestFakes(
        goal: UserGoal.fromAnswers(
          targetLevel: 'N5',
          timelineLabel: '3 months',
          timelineMonths: 3,
          startingPoint: 'Absolute beginner',
          createdAt: DateTime.now().toUtc(),
        ),
      );

  testWidgets('HomeScreen renders without overflow at every viewport',
      (tester) async {
    await verify(tester, () => const HomeScreen(), makeFakes: withGoal);
  });

  testWidgets('LearnScreen renders without overflow at every viewport',
      (tester) async {
    await verify(tester, () => const LearnScreen());
  });

  testWidgets('DictionaryScreen renders without overflow at every viewport',
      (tester) async {
    await verify(tester, () => const DictionaryScreen());
  });

  testWidgets('ProfileScreen renders without overflow at every viewport',
      (tester) async {
    await verify(tester, () => const ProfileScreen());
  });

  testWidgets('OnboardingScreen renders without overflow at every viewport',
      (tester) async {
    await verify(tester, () => const OnboardingScreen());
  });

  testWidgets('HiraganaModule renders without overflow at every viewport',
      (tester) async {
    await verify(
      tester,
      () => const KanaModuleScreen(type: Kana.typeHiragana),
    );
  });

  testWidgets('KatakanaModule renders without overflow at every viewport',
      (tester) async {
    await verify(
      tester,
      () => const KanaModuleScreen(type: Kana.typeKatakana),
    );
  });

  testWidgets('VocabularyScreen renders without overflow at every viewport',
      (tester) async {
    await verify(tester, () => const VocabularyScreen());
  });

  testWidgets('KanjiScreen renders without overflow at every viewport',
      (tester) async {
    await verify(tester, () => const KanjiScreen());
  });

  testWidgets('ReadingScreen renders without overflow at every viewport',
      (tester) async {
    await verify(tester, () => const ReadingScreen());
  });

  testWidgets('ShadowingScreen renders without overflow at every viewport',
      (tester) async {
    await verify(tester, () => const ShadowingScreen());
  });

  testWidgets('JlptMockScreen renders without overflow at every viewport',
      (tester) async {
    await verify(tester, () => const JlptMockScreen());
  });

  testWidgets('ReviewHubScreen renders without overflow at every viewport',
      (tester) async {
    await verify(tester, () => const ReviewHubScreen());
  });

  testWidgets('AnkiImportScreen renders without overflow at every viewport',
      (tester) async {
    await verify(tester, () => const AnkiImportScreen());
  });
}
