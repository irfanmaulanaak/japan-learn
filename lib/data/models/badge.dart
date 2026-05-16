class EarnedBadge {
  final String code;
  final DateTime earnedAt;

  const EarnedBadge({required this.code, required this.earnedAt});

  Map<String, Object?> toMap() => {
    'code': code,
    'earned_at': earnedAt.toIso8601String(),
  };

  factory EarnedBadge.fromMap(Map<String, Object?> map) => EarnedBadge(
    code: map['code'] as String,
    earnedAt: DateTime.parse(map['earned_at'] as String),
  );
}

class BadgeCatalog {
  static const items = <BadgeDef>[
    BadgeDef(
      code: 'first_step',
      title: 'First step',
      detail: 'Complete your first review.',
    ),
    BadgeDef(
      code: 'hiragana_done',
      title: 'Hiragana grad',
      detail: 'Master every hiragana.',
    ),
    BadgeDef(
      code: 'katakana_done',
      title: 'Katakana grad',
      detail: 'Master every katakana.',
    ),
    BadgeDef(
      code: 'streak_3',
      title: 'On a roll',
      detail: 'Hit a 3-day streak.',
    ),
    BadgeDef(
      code: 'streak_7',
      title: 'One full week',
      detail: 'Hit a 7-day streak.',
    ),
    BadgeDef(
      code: 'xp_100',
      title: 'First 100 XP',
      detail: 'Reach 100 XP.',
    ),
    BadgeDef(
      code: 'xp_500',
      title: 'Half a thousand',
      detail: 'Reach 500 XP.',
    ),
    BadgeDef(
      code: 'vocab_10',
      title: 'Word collector',
      detail: 'Master 10 vocab words.',
    ),
    BadgeDef(
      code: 'kanji_5',
      title: 'Kanji starter',
      detail: 'Master 5 kanji.',
    ),
  ];

  static BadgeDef byCode(String code) =>
      items.firstWhere((b) => b.code == code,
          orElse: () =>
              BadgeDef(code: code, title: code, detail: ''));
}

class BadgeDef {
  final String code;
  final String title;
  final String detail;
  const BadgeDef({
    required this.code,
    required this.title,
    required this.detail,
  });
}
