import 'package:flutter_test/flutter_test.dart';
import 'package:japan_learn/data/models/kana_progress.dart';

void main() {
  test('correct reviews advance SM-2 interval', () {
    final start = DateTime.utc(2026, 1, 1);
    final first = KanaProgress.initial(
      kanaId: 1,
      now: start,
    ).review(correct: true, now: start);
    final second = first.review(
      correct: true,
      now: start.add(const Duration(days: 1)),
    );

    expect(first.repetitionCount, 1);
    expect(first.intervalDays, 1);
    expect(second.repetitionCount, 2);
    expect(second.intervalDays, 6);
  });

  test('wrong review resets repetition and keeps card due', () {
    final now = DateTime.utc(2026, 1, 1);
    final progress = KanaProgress.initial(
      kanaId: 1,
      now: now,
    ).review(correct: true, now: now).review(correct: false, now: now);

    expect(progress.repetitionCount, 0);
    expect(progress.intervalDays, 0);
    expect(progress.lapseCount, 1);
    expect(progress.isDue(now), isTrue);
  });
}
