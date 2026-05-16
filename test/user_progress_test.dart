import 'package:flutter_test/flutter_test.dart';
import 'package:japan_learn/data/models/user_progress.dart';

void main() {
  test('first study event sets streak to 1 and adds XP', () {
    final now = DateTime.utc(2026, 1, 1, 10);
    final progress = UserProgress.initial(now: now)
        .recordStudy(now: now, xpEarned: 5);

    expect(progress.xp, 5);
    expect(progress.streakCount, 1);
    expect(progress.todayDone, 1);
    expect(progress.weekStudyDays.any((d) => d), isTrue);
  });

  test('consecutive-day study grows streak', () {
    final day1 = DateTime.utc(2026, 1, 1, 10);
    final day2 = DateTime.utc(2026, 1, 2, 9);

    final p1 = UserProgress.initial(now: day1)
        .recordStudy(now: day1, xpEarned: 5);
    final p2 = p1.recordStudy(now: day2, xpEarned: 5);

    expect(p2.streakCount, 2);
    expect(p2.todayDone, 1, reason: 'today_done resets at the day boundary');
    expect(p2.dayNumber, 2);
  });

  test('skipping a day resets streak to 1', () {
    final day1 = DateTime.utc(2026, 1, 1, 10);
    final day3 = DateTime.utc(2026, 1, 3, 10);

    final p = UserProgress.initial(now: day1)
        .recordStudy(now: day1, xpEarned: 5)
        .recordStudy(now: day3, xpEarned: 5);

    expect(p.streakCount, 1);
    expect(p.dayNumber, 3);
  });

  test('level rises by 1 every 100 XP', () {
    final now = DateTime.utc(2026, 1, 1);
    var p = UserProgress.initial(now: now);
    for (var i = 0; i < 21; i++) {
      p = p.recordStudy(now: now, xpEarned: 10);
    }
    expect(p.xp, 210);
    expect(p.level, 3);
  });
}
