/// SM-2 spaced repetition primitive shared across kana / vocab / kanji decks.
///
/// Keep this file pure: no DB, no Flutter. It computes the next SRS state
/// from the previous one and a binary correct/incorrect signal.
library;

class Sm2State {
  final double easiness;
  final int intervalDays;
  final int repetitionCount;
  final int lapseCount;
  final DateTime dueAt;
  final DateTime? lastReviewedAt;

  const Sm2State({
    required this.easiness,
    required this.intervalDays,
    required this.repetitionCount,
    required this.lapseCount,
    required this.dueAt,
    required this.lastReviewedAt,
  });

  factory Sm2State.initial(DateTime now) => Sm2State(
    easiness: 2.5,
    intervalDays: 0,
    repetitionCount: 0,
    lapseCount: 0,
    dueAt: now,
    lastReviewedAt: null,
  );

  bool isDue(DateTime now) => !dueAt.isAfter(now);
  bool get isNew => repetitionCount == 0 && lastReviewedAt == null;
  bool get isMastered => repetitionCount >= 4 && intervalDays >= 14;

  Sm2State review({required bool correct, required DateTime now}) {
    final quality = correct ? 5 : 2;
    final nextEasiness = _nextEasiness(easiness, quality);
    final nextRepetitions = correct ? repetitionCount + 1 : 0;
    final nextInterval = _nextInterval(
      previousInterval: intervalDays,
      correct: correct,
      repetitions: nextRepetitions,
      easiness: nextEasiness,
    );
    return Sm2State(
      easiness: nextEasiness,
      intervalDays: nextInterval,
      repetitionCount: nextRepetitions,
      lapseCount: correct ? lapseCount : lapseCount + 1,
      dueAt: now.add(Duration(days: nextInterval)),
      lastReviewedAt: now,
    );
  }
}

double _nextEasiness(double easiness, int quality) {
  final diff = 5 - quality;
  final next = easiness + (0.1 - diff * (0.08 + diff * 0.02));
  return next < 1.3 ? 1.3 : next;
}

int _nextInterval({
  required int previousInterval,
  required bool correct,
  required int repetitions,
  required double easiness,
}) {
  if (!correct) return 0;
  if (repetitions == 1) return 1;
  if (repetitions == 2) return 6;
  return (previousInterval * easiness).round().clamp(1, 365).toInt();
}
