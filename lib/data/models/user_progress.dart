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

  factory UserProgress.initial({required DateTime now}) {
    return UserProgress(
      xp: 0,
      streakCount: 0,
      modulesDone: 0,
      modulesTotal: 4,
      dayNumber: 1,
      todayDone: 0,
      reviewDue: 0,
      weekMask: '0000000',
      updatedAt: now,
    );
  }

  UserProgress recordStudy({required DateTime now, required int xpEarned}) {
    final days = weekStudyDays;
    days[now.weekday - 1] = true;

    return UserProgress(
      id: id,
      xp: xp + xpEarned,
      streakCount: streakCount == 0 ? 1 : streakCount,
      modulesDone: modulesDone,
      modulesTotal: modulesTotal,
      dayNumber: dayNumber,
      todayDone: todayDone + 1,
      reviewDue: reviewDue,
      weekMask: days.map((studied) => studied ? '1' : '0').join(),
      updatedAt: now,
    );
  }

  List<bool> get weekStudyDays {
    final padded = weekMask.padRight(7, '0');
    return List.generate(7, (i) => padded[i] == '1');
  }

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
