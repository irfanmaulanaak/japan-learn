import 'package:flutter_test/flutter_test.dart';
import 'package:japan_learn/data/srs/sm2.dart';

void main() {
  test('Sm2State.initial is new and due immediately', () {
    final now = DateTime.utc(2026, 1, 1);
    final state = Sm2State.initial(now);
    expect(state.isNew, isTrue);
    expect(state.isDue(now), isTrue);
    expect(state.intervalDays, 0);
  });

  test('Sm2State schedules intervals as 1, 6, then easiness-based growth', () {
    final t0 = DateTime.utc(2026, 1, 1);
    final s1 = Sm2State.initial(t0).review(correct: true, now: t0);
    expect(s1.intervalDays, 1);

    final s2 = s1.review(correct: true, now: t0.add(const Duration(days: 1)));
    expect(s2.intervalDays, 6);

    final s3 = s2.review(correct: true, now: t0.add(const Duration(days: 7)));
    expect(s3.intervalDays, greaterThanOrEqualTo(6));
  });

  test('Sm2State resets on wrong answer and increments lapse', () {
    final t0 = DateTime.utc(2026, 1, 1);
    final state = Sm2State.initial(t0)
        .review(correct: true, now: t0)
        .review(correct: false, now: t0);
    expect(state.repetitionCount, 0);
    expect(state.lapseCount, 1);
    expect(state.intervalDays, 0);
    expect(state.isDue(t0), isTrue);
  });

  test('Sm2State.isMastered after 4 correct with long interval', () {
    final now = DateTime.utc(2026, 1, 1);
    var s = Sm2State.initial(now);
    for (var i = 0; i < 4; i++) {
      s = s.review(correct: true, now: now);
    }
    // 1, 6, 6*ease≈15, 15*ease≈37 → mastered (rep>=4, interval>=14).
    expect(s.repetitionCount, 4);
    expect(s.intervalDays, greaterThanOrEqualTo(14));
    expect(s.isMastered, isTrue);
  });
}
