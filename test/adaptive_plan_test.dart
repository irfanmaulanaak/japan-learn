import 'package:flutter_test/flutter_test.dart';
import 'package:japan_learn/data/models/user_goal.dart';

void main() {
  UserGoal makeGoal() => UserGoal.fromAnswers(
        targetLevel: 'N5',
        timelineLabel: '3 months',
        timelineMonths: 3,
        startingPoint: 'Absolute beginner',
        createdAt: DateTime.utc(2026, 1, 1),
      );

  test('on-track plan keeps base goals', () {
    final goal = makeGoal();
    final plan = goal.adaptiveFor(
      dayNumber: 5,
      now: DateTime.utc(2026, 1, 5),
    );
    expect(plan.vocab, goal.dailyVocabGoal);
    expect(plan.kanji, goal.dailyKanjiGoal);
    expect(plan.statusLabel, 'On track');
  });

  test('falling behind scales the daily load up', () {
    final goal = makeGoal();
    final plan = goal.adaptiveFor(
      dayNumber: 5,
      now: DateTime.utc(2026, 1, 12),
    );
    expect(plan.vocab, greaterThan(goal.dailyVocabGoal));
    expect(plan.kanji, greaterThanOrEqualTo(goal.dailyKanjiGoal));
    expect(plan.statusLabel, 'Catching up');
  });

  test('being ahead eases the daily load', () {
    final goal = makeGoal();
    final plan = goal.adaptiveFor(
      dayNumber: 15,
      now: DateTime.utc(2026, 1, 8),
    );
    expect(plan.vocab, lessThanOrEqualTo(goal.dailyVocabGoal));
    expect(plan.statusLabel, 'Ahead of plan');
  });
}
