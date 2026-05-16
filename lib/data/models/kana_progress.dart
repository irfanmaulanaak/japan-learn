import '../srs/sm2.dart';

class KanaProgress {
  final int kanaId;
  final Sm2State state;

  const KanaProgress({required this.kanaId, required this.state});

  factory KanaProgress.initial({required int kanaId, required DateTime now}) =>
      KanaProgress(kanaId: kanaId, state: Sm2State.initial(now));

  double get easiness => state.easiness;
  int get intervalDays => state.intervalDays;
  int get repetitionCount => state.repetitionCount;
  int get lapseCount => state.lapseCount;
  DateTime get dueAt => state.dueAt;
  DateTime? get lastReviewedAt => state.lastReviewedAt;

  bool isDue(DateTime now) => state.isDue(now);
  bool get isNew => state.isNew;
  bool get isMastered => state.isMastered;

  KanaProgress review({required bool correct, required DateTime now}) =>
      KanaProgress(
        kanaId: kanaId,
        state: state.review(correct: correct, now: now),
      );

  Map<String, Object?> toMap() => {
    'kana_id': kanaId,
    'easiness': state.easiness,
    'interval_days': state.intervalDays,
    'repetition_count': state.repetitionCount,
    'lapse_count': state.lapseCount,
    'due_at': state.dueAt.toIso8601String(),
    'last_reviewed_at': state.lastReviewedAt?.toIso8601String(),
  };

  factory KanaProgress.fromMap(Map<String, Object?> map) => KanaProgress(
    kanaId: map['kana_id'] as int,
    state: Sm2State(
      easiness: (map['easiness'] as num).toDouble(),
      intervalDays: map['interval_days'] as int,
      repetitionCount: map['repetition_count'] as int,
      lapseCount: map['lapse_count'] as int,
      dueAt: DateTime.parse(map['due_at'] as String),
      lastReviewedAt:
          map['last_reviewed_at'] == null
              ? null
              : DateTime.parse(map['last_reviewed_at'] as String),
    ),
  );
}
