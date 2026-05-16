class UserProgress {
  static const singleRowId = 1;

  final int id;
  final int xp;
  final int streakCount;
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
    required this.modulesDone,
    required this.modulesTotal,
    required this.dayNumber,
    required this.todayDone,
    required this.reviewDue,
    required this.weekMask,
    required this.updatedAt,
  });

  static const int defaultModulesTotal = 6;

  factory UserProgress.initial({required DateTime now}) {
    return UserProgress(
      xp: 0,
      streakCount: 0,
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
    final nextStreak = _nextStreak(daysSinceLast);
    final nextTodayDone = newDay ? 1 : todayDone + 1;
    final nextDayNumber = newDay ? dayNumber + daysSinceLast : dayNumber;

    final days = newDay ? _emptyWeek() : weekStudyDays;
    days[now.weekday - 1] = true;

    return UserProgress(
      id: id,
      xp: xp + xpEarned,
      streakCount: nextStreak,
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
    modulesDone: done.clamp(0, modulesTotal),
    modulesTotal: modulesTotal,
    dayNumber: dayNumber,
    todayDone: todayDone,
    reviewDue: reviewDue,
    weekMask: weekMask,
    updatedAt: updatedAt,
  );

  int _nextStreak(int daysSinceLast) {
    if (streakCount == 0) return 1;
    if (daysSinceLast == 0) return streakCount;
    if (daysSinceLast == 1) return streakCount + 1;
    return 1;
  }

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
    modulesDone: map['modules_done'] as int,
    modulesTotal: map['modules_total'] as int,
    dayNumber: map['day_number'] as int,
    todayDone: map['today_done'] as int,
    reviewDue: map['review_due'] as int,
    weekMask: map['week_mask'] as String,
    updatedAt: DateTime.parse(map['updated_at'] as String),
  );
}
