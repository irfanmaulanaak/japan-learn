class Vocabulary {
  final int? id;
  final String word;
  final String reading;
  final String meaning;
  final String partOfSpeech;
  final String level;
  final String exampleJa;
  final String exampleEn;

  const Vocabulary({
    this.id,
    required this.word,
    required this.reading,
    required this.meaning,
    required this.partOfSpeech,
    required this.level,
    required this.exampleJa,
    required this.exampleEn,
  });

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'word': word,
    'reading': reading,
    'meaning': meaning,
    'part_of_speech': partOfSpeech,
    'level': level,
    'example_ja': exampleJa,
    'example_en': exampleEn,
  };

  factory Vocabulary.fromMap(Map<String, Object?> map) => Vocabulary(
    id: map['id'] as int?,
    word: map['word'] as String,
    reading: map['reading'] as String,
    meaning: map['meaning'] as String,
    partOfSpeech: map['part_of_speech'] as String,
    level: map['level'] as String,
    exampleJa: (map['example_ja'] as String?) ?? '',
    exampleEn: (map['example_en'] as String?) ?? '',
  );
}
