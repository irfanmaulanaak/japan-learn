import '../srs/sm2.dart';

/// Generic SRS progress row for vocab and kanji decks.
class CardProgress {
  static const deckVocab = 'vocab';
  static const deckKanji = 'kanji';

  final String deck;
  final int itemId;
  final Sm2State state;

  const CardProgress({
    required this.deck,
    required this.itemId,
    required this.state,
  });

  factory CardProgress.initial({
    required String deck,
    required int itemId,
    required DateTime now,
  }) =>
      CardProgress(deck: deck, itemId: itemId, state: Sm2State.initial(now));

  CardProgress review({required bool correct, required DateTime now}) =>
      CardProgress(
        deck: deck,
        itemId: itemId,
        state: state.review(correct: correct, now: now),
      );

  Map<String, Object?> toMap() => {
    'deck': deck,
    'item_id': itemId,
    'easiness': state.easiness,
    'interval_days': state.intervalDays,
    'repetition_count': state.repetitionCount,
    'lapse_count': state.lapseCount,
    'due_at': state.dueAt.toIso8601String(),
    'last_reviewed_at': state.lastReviewedAt?.toIso8601String(),
  };

  factory CardProgress.fromMap(Map<String, Object?> map) => CardProgress(
    deck: map['deck'] as String,
    itemId: map['item_id'] as int,
    state: Sm2State(
      easiness: (map['easiness'] as num).toDouble(),
      intervalDays: map['interval_days'] as int,
      repetitionCount: map['repetition_count'] as int,
      lapseCount: map['lapse_count'] as int,
      dueAt: DateTime.parse(map['due_at'] as String),
      lastReviewedAt:
          map['last_reviewed_at'] == null
              ? null
              : DateTime.parse(map['last_reviewed_at'] as String),
    ),
  );
}
