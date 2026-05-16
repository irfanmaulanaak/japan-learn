class UserGoal {
  static const singleRowId = 1;

  final int id;
  final String targetLevel;
  final String timelineLabel;
  final int timelineMonths;
  final String startingPoint;
  final int dailyKanjiGoal;
  final int dailyVocabGoal;
  final int dailyReviewMinutes;
  final DateTime createdAt;

  const UserGoal({
    this.id = singleRowId,
    required this.targetLevel,
    required this.timelineLabel,
    required this.timelineMonths,
    required this.startingPoint,
    required this.dailyKanjiGoal,
    required this.dailyVocabGoal,
    required this.dailyReviewMinutes,
    required this.createdAt,
  });

  factory UserGoal.fromAnswers({
    required String targetLevel,
    required String timelineLabel,
    required int timelineMonths,
    required String startingPoint,
    required DateTime createdAt,
  }) {
    final days = timelineMonths * 30;
    final kanjiTotal = _kanjiTotals[targetLevel] ?? _kanjiTotals['N5']!;
    final vocabTotal = _vocabTotals[targetLevel] ?? _vocabTotals['N5']!;
    final knownRatio = _knownRatios[startingPoint] ?? 0;
    final remainingRatio = 1 - knownRatio;

    final dailyKanji = ((kanjiTotal * remainingRatio) / days).ceil();
    final dailyVocab = ((vocabTotal * remainingRatio) / days).ceil();
    final minKanji = timelineMonths <= 3 ? 5 : (timelineMonths <= 6 ? 3 : 1);
    final minVocab = timelineMonths <= 3 ? 10 : 5;

    return UserGoal(
      targetLevel: targetLevel,
      timelineLabel: timelineLabel,
      timelineMonths: timelineMonths,
      startingPoint: startingPoint,
      dailyKanjiGoal: dailyKanji.clamp(minKanji, 30).toInt(),
      dailyVocabGoal: dailyVocab.clamp(minVocab, 80).toInt(),
      dailyReviewMinutes: timelineMonths <= 3 ? 15 : 10,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toMap() => {
    'id': id,
    'target_level': targetLevel,
    'timeline_label': timelineLabel,
    'timeline_months': timelineMonths,
    'starting_point': startingPoint,
    'daily_kanji_goal': dailyKanjiGoal,
    'daily_vocab_goal': dailyVocabGoal,
    'daily_review_minutes': dailyReviewMinutes,
    'created_at': createdAt.toIso8601String(),
  };

  factory UserGoal.fromMap(Map<String, Object?> map) => UserGoal(
    id: map['id'] as int,
    targetLevel: map['target_level'] as String,
    timelineLabel: map['timeline_label'] as String,
    timelineMonths: map['timeline_months'] as int,
    startingPoint: map['starting_point'] as String,
    dailyKanjiGoal: map['daily_kanji_goal'] as int,
    dailyVocabGoal: map['daily_vocab_goal'] as int,
    dailyReviewMinutes: map['daily_review_minutes'] as int,
    createdAt: DateTime.parse(map['created_at'] as String),
  );

  /// Returns an adjusted daily plan based on how far ahead/behind the
  /// learner is. If `dayNumber` is more than 3 days behind the calendar
  /// day-of-plan, daily goals scale up by 25%; if 3+ ahead, they ease 20%.
  AdaptiveDailyPlan adaptiveFor({required int dayNumber, required DateTime now}) {
    final elapsedDays = now.difference(createdAt).inDays + 1;
    final delta = elapsedDays - dayNumber; // positive when behind plan
    double scale = 1.0;
    if (delta >= 3) scale = 1.25;
    if (delta <= -3) scale = 0.8;
    return AdaptiveDailyPlan(
      kanji: (dailyKanjiGoal * scale).round().clamp(1, 40),
      vocab: (dailyVocabGoal * scale).round().clamp(1, 100),
      reviewMinutes: (dailyReviewMinutes * scale).round().clamp(5, 60),
      behindByDays: delta,
    );
  }
}

class AdaptiveDailyPlan {
  final int kanji;
  final int vocab;
  final int reviewMinutes;
  final int behindByDays;
  const AdaptiveDailyPlan({
    required this.kanji,
    required this.vocab,
    required this.reviewMinutes,
    required this.behindByDays,
  });

  String get statusLabel {
    if (behindByDays >= 3) return 'Catching up';
    if (behindByDays <= -3) return 'Ahead of plan';
    return 'On track';
  }

  static const _kanjiTotals = {
    'N5': 100,
    'N4': 300,
    'N3': 650,
    'N2': 1000,
    'N1': 2000,
  };

  static const _vocabTotals = {
    'N5': 800,
    'N4': 1500,
    'N3': 3700,
    'N2': 6000,
    'N1': 10000,
  };

  static const _knownRatios = {
    'Absolute beginner': 0.0,
    'Know hiragana': 0.08,
    'Some kanji': 0.18,
    'Returning learner': 0.28,
  };
}
