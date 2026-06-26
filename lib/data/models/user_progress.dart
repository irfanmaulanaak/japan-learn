class UserProgress {
  static const singleRowId = 1;

  final int id;
  final int xp;
  final int streakCount;
  final int freezeTokens;
  final int modulesDone;
  final int modulesTotal;
  final int dayNumber;
  final int todayDone;
  final int reviewDue;
  final String weekMask;
  final DateTime updatedAt;

  const UserProgress({
    this.id = singleRowId,
    required this.xp,
    required this.streakCount,
    this.freezeTokens = 0,
    required this.modulesDone,
    required this.modulesTotal,
    required this.dayNumber,
    required this.todayDone,
    required this.reviewDue,
    required this.weekMask,
    required this.updatedAt,
  });

  static const int defaultModulesTotal = 6;

  /// Most freezes a learner can stockpile. Keeps the safety net meaningful
  /// without making streaks feel free.
  static const int maxFreezeTokens = 2;

  /// Earn one freeze each time the streak reaches a multiple of this.
  static const int _freezeEarnEvery = 5;

  factory UserProgress.initial({required DateTime now}) {
    return UserProgress(
      xp: 0,
      streakCount: 0,
      freezeTokens: 0,
      modulesDone: 0,
      modulesTotal: defaultModulesTotal,
      dayNumber: 1,
      todayDone: 0,
      reviewDue: 0,
      weekMask: '0000000',
      updatedAt: now,
    );
  }

  /// Records a single lesson event and handles day/streak rollover and
  /// reset-on-new-day for today's progress.
  UserProgress recordStudy({required DateTime now, required int xpEarned}) {
    final lastDate = _dateOnly(updatedAt);
    final today = _dateOnly(now);
    final daysSinceLast = today.difference(lastDate).inDays;

    final newDay = daysSinceLast != 0;
    final nextTodayDone = newDay ? 1 : todayDone + 1;
    final nextDayNumber = newDay ? dayNumber + daysSinceLast : dayNumber;

    // Streak + freeze. A freeze silently absorbs exactly one missed day so a
    // single slip doesn't wipe out a hard-won streak. Freezes are earned at
    // streak milestones, capped, so they stay meaningful.
    int nextStreak;
    var nextFreeze = freezeTokens;
    if (streakCount == 0) {
      nextStreak = 1;
    } else if (daysSinceLast == 0) {
      nextStreak = streakCount;
    } else if (daysSinceLast == 1) {
      nextStreak = streakCount + 1;
    } else if (daysSinceLast == 2 && freezeTokens > 0) {
      nextStreak = streakCount + 1; // one missed day, covered by a freeze
      nextFreeze = freezeTokens - 1;
    } else {
      nextStreak = 1; // multi-day gap, or no freeze to spend
    }

    if (newDay &&
        nextStreak % _freezeEarnEvery == 0 &&
        nextFreeze < maxFreezeTokens) {
      nextFreeze += 1;
    }

    final days = newDay ? _emptyWeek() : weekStudyDays;
    days[now.weekday - 1] = true;

    return UserProgress(
      id: id,
      xp: xp + xpEarned,
      streakCount: nextStreak,
      freezeTokens: nextFreeze,
      modulesDone: modulesDone,
      modulesTotal: modulesTotal,
      dayNumber: nextDayNumber,
      todayDone: nextTodayDone,
      reviewDue: reviewDue,
      weekMask: days.map((studied) => studied ? '1' : '0').join(),
      updatedAt: now,
    );
  }

  UserProgress withReviewDue(int count) => UserProgress(
    id: id,
    xp: xp,
    streakCount: streakCount,
    freezeTokens: freezeTokens,
    modulesDone: modulesDone,
    modulesTotal: modulesTotal,
    dayNumber: dayNumber,
    todayDone: todayDone,
    reviewDue: count,
    weekMask: weekMask,
    updatedAt: updatedAt,
  );

  UserProgress withModulesDone(int done) => UserProgress(
    id: id,
    xp: xp,
    streakCount: streakCount,
    freezeTokens: freezeTokens,
    modulesDone: done.clamp(0, modulesTotal),
    modulesTotal: modulesTotal,
    dayNumber: dayNumber,
    todayDone: todayDone,
    reviewDue: reviewDue,
    weekMask: weekMask,
    updatedAt: updatedAt,
  );

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static List<bool> _emptyWeek() => List.filled(7, false);

  List<bool> get weekStudyDays {
    final padded = weekMask.padRight(7, '0');
    return List.generate(7, (i) => padded[i] == '1');
  }

  int get level => (xp / 100).floor() + 1;

  Map<String, Object?> toMap() => {
    'id': id,
    'xp': xp,
    'streak_count': streakCount,
    'freeze_tokens': freezeTokens,
    'modules_done': modulesDone,
    'modules_total': modulesTotal,
    'day_number': dayNumber,
    'today_done': todayDone,
    'review_due': reviewDue,
    'week_mask': weekMask,
    'updated_at': updatedAt.toIso8601String(),
  };

  factory UserProgress.fromMap(Map<String, Object?> map) => UserProgress(
    id: map['id'] as int,
    xp: map['xp'] as int,
    streakCount: map['streak_count'] as int,
    freezeTokens: (map['freeze_tokens'] as int?) ?? 0,
    modulesDone: map['modules_done'] as int,
    modulesTotal: map['modules_total'] as int,
    dayNumber: map['day_number'] as int,
    todayDone: map['today_done'] as int,
    reviewDue: map['review_due'] as int,
    weekMask: map['week_mask'] as String,
    updatedAt: DateTime.parse(map['updated_at'] as String),
  );
}
