import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:japan_learn/data/database/database_helper.dart';
import 'package:japan_learn/data/models/user_goal.dart';
import 'package:japan_learn/data/models/user_progress.dart';
import 'package:japan_learn/data/providers.dart';
import 'package:japan_learn/data/repositories/user_goal_repository.dart';
import 'package:japan_learn/data/repositories/user_progress_repository.dart';
import 'package:japan_learn/main.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  test('generates a simple daily plan from onboarding answers', () {
    final goal = UserGoal.fromAnswers(
      targetLevel: 'N5',
      timelineLabel: '3 months',
      timelineMonths: 3,
      startingPoint: 'Absolute beginner',
      createdAt: DateTime.utc(2026, 1),
    );

    expect(goal.dailyKanjiGoal, 5);
    expect(goal.dailyVocabGoal, 10);
    expect(goal.dailyReviewMinutes, 15);
  });

  test('initial progress starts empty', () {
    final progress = UserProgress.initial(now: DateTime.utc(2026, 1));

    expect(progress.xp, 0);
    expect(progress.streakCount, 0);
    expect(progress.modulesDone, 0);
    expect(progress.weekStudyDays, List.filled(7, false));
  });

  testWidgets('App shows onboarding until a goal is saved', (tester) async {
    final repo = _FakeUserGoalRepository();
    final progressRepo = _FakeUserProgressRepository();
    await _pumpApp(tester, repo, progressRepo);

    expect(find.text('Build your daily path'), findsOneWidget);

    await tester.tap(find.text('Start setup'));
    await tester.pump(const Duration(milliseconds: 260));

    await tester.tap(find.text('N4'));
    await tester.tap(find.text('Continue'));
    await tester.pump(const Duration(milliseconds: 260));

    await tester.tap(find.text('6 months'));
    await tester.tap(find.text('Continue'));
    await tester.pump(const Duration(milliseconds: 260));

    await tester.tap(find.text('Know hiragana'));
    await tester.tap(find.text('Finish'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(repo.goal?.targetLevel, 'N4');
    expect(repo.goal?.timelineMonths, 6);
    expect(repo.goal?.startingPoint, 'Know hiragana');
    expect(find.text('おかえり。'), findsOneWidget);

    await _disposeApp(tester);
  });

  testWidgets('App renders home when a saved goal exists', (tester) async {
    final repo = _FakeUserGoalRepository(_goal());
    final progressRepo = _FakeUserProgressRepository();
    await _pumpApp(tester, repo, progressRepo);

    expect(find.text('おかえり。'), findsOneWidget);
    expect(find.text('10 vocab + 5 kanji'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('JLPT N5'), 200);

    expect(find.text('JLPT N5'), findsOneWidget);
    expect(find.text('target Apr 2026'), findsOneWidget);
    expect(find.text('Build your daily path'), findsNothing);

    await _disposeApp(tester);
  });
}

Future<void> _pumpApp(
  WidgetTester tester,
  _FakeUserGoalRepository repo,
  _FakeUserProgressRepository progressRepo,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userGoalRepositoryProvider.overrideWithValue(repo),
        userProgressRepositoryProvider.overrideWithValue(progressRepo),
      ],
      child: const JapanLearnApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump();
}

Future<void> _disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
}

UserGoal _goal() {
  return UserGoal.fromAnswers(
    targetLevel: 'N5',
    timelineLabel: '3 months',
    timelineMonths: 3,
    startingPoint: 'Absolute beginner',
    createdAt: DateTime.utc(2026, 1),
  );
}

class _FakeUserGoalRepository extends UserGoalRepository {
  _FakeUserGoalRepository([this.goal]) : super(DatabaseHelper.instance);

  UserGoal? goal;

  @override
  Future<UserGoal?> current() async => goal;

  @override
  Future<void> save(UserGoal goal) async {
    this.goal = goal;
  }
}

class _FakeUserProgressRepository extends UserProgressRepository {
  _FakeUserProgressRepository([UserProgress? progress])
    : progress = progress ?? UserProgress.initial(now: DateTime.utc(2026, 1)),
      super(DatabaseHelper.instance);

  UserProgress progress;

  @override
  Future<UserProgress> currentOrCreate() async => progress;

  @override
  Future<void> save(UserProgress progress) async {
    this.progress = progress;
  }
}
