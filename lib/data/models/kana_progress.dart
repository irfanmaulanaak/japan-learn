class KanaProgress {
  final int kanaId;
  final double easiness;
  final int intervalDays;
  final int repetitionCount;
  final int lapseCount;
  final DateTime dueAt;
  final DateTime? lastReviewedAt;

  const KanaProgress({
    required this.kanaId,
    required this.easiness,
    required this.intervalDays,
    required this.repetitionCount,
    required this.lapseCount,
    required this.dueAt,
    required this.lastReviewedAt,
  });

  factory KanaProgress.initial({required int kanaId, required DateTime now}) {
    return KanaProgress(
      kanaId: kanaId,
      easiness: 2.5,
      intervalDays: 0,
      repetitionCount: 0,
      lapseCount: 0,
      dueAt: now,
      lastReviewedAt: null,
    );
  }

  bool isDue(DateTime now) => !dueAt.isAfter(now);

  bool get isNew => repetitionCount == 0 && lastReviewedAt == null;

  bool get isMastered => repetitionCount >= 4 && intervalDays >= 14;

  KanaProgress review({required bool correct, required DateTime now}) {
    final quality = correct ? 5 : 2;
    final nextEasiness = _nextEasiness(quality);
    final nextRepetitions = correct ? repetitionCount + 1 : 0;
    final nextInterval = _nextInterval(correct, nextRepetitions, nextEasiness);

    return KanaProgress(
      kanaId: kanaId,
      easiness: nextEasiness,
      intervalDays: nextInterval,
      repetitionCount: nextRepetitions,
      lapseCount: correct ? lapseCount : lapseCount + 1,
      dueAt: now.add(Duration(days: nextInterval)),
      lastReviewedAt: now,
    );
  }

  Map<String, Object?> toMap() => {
    'kana_id': kanaId,
    'easiness': easiness,
    'interval_days': intervalDays,
    'repetition_count': repetitionCount,
    'lapse_count': lapseCount,
    'due_at': dueAt.toIso8601String(),
    'last_reviewed_at': lastReviewedAt?.toIso8601String(),
  };

  factory KanaProgress.fromMap(Map<String, Object?> map) => KanaProgress(
    kanaId: map['kana_id'] as int,
    easiness: map['easiness'] as double,
    intervalDays: map['interval_days'] as int,
    repetitionCount: map['repetition_count'] as int,
    lapseCount: map['lapse_count'] as int,
    dueAt: DateTime.parse(map['due_at'] as String),
    lastReviewedAt:
        map['last_reviewed_at'] == null
            ? null
            : DateTime.parse(map['last_reviewed_at'] as String),
  );

  double _nextEasiness(int quality) {
    final diff = 5 - quality;
    final next = easiness + (0.1 - diff * (0.08 + diff * 0.02));
    return next < 1.3 ? 1.3 : next;
  }

  int _nextInterval(bool correct, int repetitions, double nextEasiness) {
    if (!correct) return 0;
    if (repetitions == 1) return 1;
    if (repetitions == 2) return 6;
    return (intervalDays * nextEasiness).round().clamp(1, 365).toInt();
  }
}
