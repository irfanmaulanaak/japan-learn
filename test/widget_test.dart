import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:japan_learn/data/database/database_helper.dart';
import 'package:japan_learn/data/models/user_goal.dart';
import 'package:japan_learn/data/providers.dart';
import 'package:japan_learn/data/repositories/user_goal_repository.dart';
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

  testWidgets('App shows onboarding until a goal is saved', (tester) async {
    final repo = _FakeUserGoalRepository();
    await _pumpApp(tester, repo);

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
    await tester.pump(const Duration(milliseconds: 260));

    expect(repo.goal?.targetLevel, 'N4');
    expect(repo.goal?.timelineMonths, 6);
    expect(repo.goal?.startingPoint, 'Know hiragana');
    expect(find.text('おかえり。'), findsOneWidget);
  });

  testWidgets('App renders home when a saved goal exists', (tester) async {
    final repo = _FakeUserGoalRepository(_goal());
    await _pumpApp(tester, repo);

    expect(find.text('おかえり。'), findsOneWidget);
    expect(find.text('Build your daily path'), findsNothing);
  });
}

Future<void> _pumpApp(WidgetTester tester, _FakeUserGoalRepository repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [userGoalRepositoryProvider.overrideWithValue(repo)],
      child: const JapanLearnApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 260));
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
