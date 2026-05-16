class Bookmark {
  static const kindVocab = 'vocab';
  static const kindKanji = 'kanji';

  final int? id;
  final String kind;
  final int itemId;
  final DateTime createdAt;

  const Bookmark({
    this.id,
    required this.kind,
    required this.itemId,
    required this.createdAt,
  });

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'kind': kind,
    'item_id': itemId,
    'created_at': createdAt.toIso8601String(),
  };

  factory Bookmark.fromMap(Map<String, Object?> map) => Bookmark(
    id: map['id'] as int?,
    kind: map['kind'] as String,
    itemId: map['item_id'] as int,
    createdAt: DateTime.parse(map['created_at'] as String),
  );
}
