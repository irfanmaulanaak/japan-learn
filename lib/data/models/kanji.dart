class Kanji {
  final int? id;
  final String character;
  final String meaning;
  final String onyomi;
  final String kunyomi;
  final String radicals;
  final int strokes;
  final String level;

  const Kanji({
    this.id,
    required this.character,
    required this.meaning,
    required this.onyomi,
    required this.kunyomi,
    required this.radicals,
    required this.strokes,
    required this.level,
  });

  List<String> get radicalList =>
      radicals.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'character': character,
    'meaning': meaning,
    'onyomi': onyomi,
    'kunyomi': kunyomi,
    'radicals': radicals,
    'strokes': strokes,
    'level': level,
  };

  factory Kanji.fromMap(Map<String, Object?> map) => Kanji(
    id: map['id'] as int?,
    character: map['character'] as String,
    meaning: map['meaning'] as String,
    onyomi: (map['onyomi'] as String?) ?? '',
    kunyomi: (map['kunyomi'] as String?) ?? '',
    radicals: (map['radicals'] as String?) ?? '',
    strokes: map['strokes'] as int,
    level: map['level'] as String,
  );
}
