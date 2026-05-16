import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:japan_learn/data/models/user_goal.dart';
import 'package:japan_learn/data/providers.dart';
import 'package:japan_learn/theme/app_theme.dart';

import 'fakes.dart';

/// Common viewport sizes we want to keep overflow-free.
const List<Size> kTestViewports = [
  Size(320, 568), // iPhone SE 1st gen, smallest mainstream phone
  Size(360, 640), // tiny Android
  Size(390, 844), // iPhone 13/14
  Size(412, 915), // Pixel 6
];

class TestFakes {
  final FakeUserGoalRepository goalRepo;
  final FakeUserProgressRepository progressRepo;
  final FakeKanaRepository kanaRepo;
  final FakeKanaProgressRepository kanaProgressRepo;
  final FakeVocabularyRepository vocabRepo;
  final FakeKanjiRepository kanjiRepo;
  final FakeCardProgressRepository cardProgressRepo;
  final FakeBookmarkRepository bookmarkRepo;
  final FakeBadgeRepository badgeRepo;

  TestFakes({UserGoal? goal})
      : goalRepo = FakeUserGoalRepository(goal),
        progressRepo = FakeUserProgressRepository(),
        kanaRepo = FakeKanaRepository(),
        kanaProgressRepo = FakeKanaProgressRepository(),
        vocabRepo = FakeVocabularyRepository(),
        kanjiRepo = FakeKanjiRepository(),
        cardProgressRepo = FakeCardProgressRepository(),
        bookmarkRepo = FakeBookmarkRepository(),
        badgeRepo = FakeBadgeRepository();

  List<Override> overrides() => [
        userGoalRepositoryProvider.overrideWithValue(goalRepo),
        userProgressRepositoryProvider.overrideWithValue(progressRepo),
        kanaRepositoryProvider.overrideWithValue(kanaRepo),
        kanaProgressRepositoryProvider.overrideWithValue(kanaProgressRepo),
        vocabularyRepositoryProvider.overrideWithValue(vocabRepo),
        kanjiRepositoryProvider.overrideWithValue(kanjiRepo),
        cardProgressRepositoryProvider.overrideWithValue(cardProgressRepo),
        bookmarkRepositoryProvider.overrideWithValue(bookmarkRepo),
        badgeRepositoryProvider.overrideWithValue(badgeRepo),
      ];
}

/// Sets the test viewport for the surrounding test.
Future<void> setViewport(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// Pumps `widget` inside a MaterialApp wrapped in ProviderScope with all
/// repository fakes. Pumps a few frames so async providers resolve and
/// implicit animations settle.
Future<void> pumpScreen(
  WidgetTester tester,
  Widget widget, {
  TestFakes? fakes,
}) async {
  final f = fakes ?? TestFakes();
  await tester.pumpWidget(
    ProviderScope(
      overrides: f.overrides(),
      child: MaterialApp(
        theme: buildAppTheme(),
        home: widget,
      ),
    ),
  );
  // Drain provider micro-tasks + initial animations.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 400));
}

/// Disables fetching fonts so widget tests run hermetically.
void disableGoogleFontsFetch() {
  GoogleFonts.config.allowRuntimeFetching = false;
}

/// Runs `body` at every viewport in [kTestViewports] and asserts no
/// `RenderFlex` overflow (or any other) exception fired.
Future<void> expectNoOverflowAcrossViewports(
  WidgetTester tester,
  Future<void> Function() body,
) async {
  for (final size in kTestViewports) {
    await setViewport(tester, size);
    await body();
    final problem = tester.takeException();
    expect(
      problem,
      isNull,
      reason: 'Overflow / exception at viewport $size: $problem',
    );
  }
}
