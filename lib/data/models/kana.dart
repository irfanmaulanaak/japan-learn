class Kana {
  final int? id;
  final String character;
  final String romaji;
  final String type;
  final String rowGroup;
  final int orderIndex;

  const Kana({
    this.id,
    required this.character,
    required this.romaji,
    required this.type,
    required this.rowGroup,
    required this.orderIndex,
  });

  static const typeHiragana = 'hiragana';
  static const typeKatakana = 'katakana';

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'character': character,
        'romaji': romaji,
        'type': type,
        'row_group': rowGroup,
        'order_index': orderIndex,
      };

  factory Kana.fromMap(Map<String, Object?> map) => Kana(
        id: map['id'] as int?,
        character: map['character'] as String,
        romaji: map['romaji'] as String,
        type: map['type'] as String,
        rowGroup: map['row_group'] as String,
        orderIndex: map['order_index'] as int,
      );
}
