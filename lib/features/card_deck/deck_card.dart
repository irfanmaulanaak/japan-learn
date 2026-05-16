/// Front/back of a generic flashcard. Used by vocab and kanji decks.
class DeckCard {
  final int id;
  final String front;
  final String back;
  final String? subtitle; // e.g. reading for vocab, on/kun for kanji
  final String? meta; // e.g. POS / level
  final String? exampleJa;
  final String? exampleEn;

  const DeckCard({
    required this.id,
    required this.front,
    required this.back,
    this.subtitle,
    this.meta,
    this.exampleJa,
    this.exampleEn,
  });
}
