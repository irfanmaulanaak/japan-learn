import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/database_helper.dart';
import 'models/badge.dart';
import 'models/bookmark.dart';
import 'models/card_progress.dart';
import 'models/kana.dart';
import 'models/kana_progress.dart';
import 'models/kanji.dart';
import 'models/user_goal.dart';
import 'models/user_progress.dart';
import 'models/vocabulary.dart';
import 'repositories/badge_repository.dart';
import 'repositories/bookmark_repository.dart';
import 'repositories/card_progress_repository.dart';
import 'repositories/kana_progress_repository.dart';
import 'repositories/kana_repository.dart';
import 'repositories/kanji_repository.dart';
import 'repositories/user_goal_repository.dart';
import 'repositories/user_progress_repository.dart';
import 'repositories/vocabulary_repository.dart';

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

final kanaRepositoryProvider = Provider<KanaRepository>((ref) {
  return KanaRepository(ref.watch(databaseHelperProvider));
});

final kanaProgressRepositoryProvider = Provider<KanaProgressRepository>((ref) {
  return KanaProgressRepository(ref.watch(databaseHelperProvider));
});

final userGoalRepositoryProvider = Provider<UserGoalRepository>((ref) {
  return UserGoalRepository(ref.watch(databaseHelperProvider));
});

final userProgressRepositoryProvider = Provider<UserProgressRepository>((ref) {
  return UserProgressRepository(ref.watch(databaseHelperProvider));
});

final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  return VocabularyRepository(ref.watch(databaseHelperProvider));
});

final kanjiRepositoryProvider = Provider<KanjiRepository>((ref) {
  return KanjiRepository(ref.watch(databaseHelperProvider));
});

final cardProgressRepositoryProvider = Provider<CardProgressRepository>((ref) {
  return CardProgressRepository(ref.watch(databaseHelperProvider));
});

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepository(ref.watch(databaseHelperProvider));
});

final badgeRepositoryProvider = Provider<BadgeRepository>((ref) {
  return BadgeRepository(ref.watch(databaseHelperProvider));
});

final userGoalProvider = FutureProvider<UserGoal?>((ref) {
  return ref.watch(userGoalRepositoryProvider).current();
});

final userProgressProvider = FutureProvider<UserProgress>((ref) {
  return ref.watch(userProgressRepositoryProvider).currentOrCreate();
});

final hiraganaListProvider = FutureProvider<List<Kana>>((ref) {
  return ref.watch(kanaRepositoryProvider).all(type: Kana.typeHiragana);
});

final hiraganaProgressProvider = FutureProvider<Map<int, KanaProgress>>((
  ref,
) async {
  final kana = await ref.watch(hiraganaListProvider.future);
  final ids = kana.map((k) => k.id).nonNulls.toList();
  return ref.watch(kanaProgressRepositoryProvider).byKanaIds(ids);
});

final katakanaListProvider = FutureProvider<List<Kana>>((ref) {
  return ref.watch(kanaRepositoryProvider).all(type: Kana.typeKatakana);
});

final katakanaProgressProvider = FutureProvider<Map<int, KanaProgress>>((
  ref,
) async {
  final kana = await ref.watch(katakanaListProvider.future);
  final ids = kana.map((k) => k.id).nonNulls.toList();
  return ref.watch(kanaProgressRepositoryProvider).byKanaIds(ids);
});

final vocabularyListProvider = FutureProvider<List<Vocabulary>>((ref) {
  return ref.watch(vocabularyRepositoryProvider).all();
});

final vocabularyByLevelProvider = FutureProvider.family<List<Vocabulary>, String>(
  (ref, level) =>
      ref.watch(vocabularyRepositoryProvider).byLevel(level),
);

final kanjiListProvider = FutureProvider<List<Kanji>>((ref) {
  return ref.watch(kanjiRepositoryProvider).all();
});

final kanjiByLevelProvider = FutureProvider.family<List<Kanji>, String>(
  (ref, level) => ref.watch(kanjiRepositoryProvider).byLevel(level),
);

final vocabularyProgressProvider =
    FutureProvider<Map<int, CardProgress>>((ref) async {
  final words = await ref.watch(vocabularyListProvider.future);
  final ids = words.map((w) => w.id).nonNulls.toList();
  return ref
      .watch(cardProgressRepositoryProvider)
      .byDeckIds(deck: CardProgress.deckVocab, itemIds: ids);
});

final kanjiProgressProvider =
    FutureProvider<Map<int, CardProgress>>((ref) async {
  final kanji = await ref.watch(kanjiListProvider.future);
  final ids = kanji.map((k) => k.id).nonNulls.toList();
  return ref
      .watch(cardProgressRepositoryProvider)
      .byDeckIds(deck: CardProgress.deckKanji, itemIds: ids);
});

/// Total review-due across hiragana/katakana/vocab/kanji.
final reviewDueCountProvider = FutureProvider<int>((ref) async {
  final now = DateTime.now();

  final hira = await ref.watch(hiraganaProgressProvider.future);
  final kata = await ref.watch(katakanaProgressProvider.future);
  final vocab = await ref.watch(vocabularyProgressProvider.future);
  final kanji = await ref.watch(kanjiProgressProvider.future);

  var due = 0;
  for (final p in hira.values) {
    if (!p.isNew && p.isDue(now)) due++;
  }
  for (final p in kata.values) {
    if (!p.isNew && p.isDue(now)) due++;
  }
  for (final p in vocab.values) {
    if (!p.state.isNew && p.state.isDue(now)) due++;
  }
  for (final p in kanji.values) {
    if (!p.state.isNew && p.state.isDue(now)) due++;
  }
  return due;
});

final bookmarksProvider = FutureProvider<List<Bookmark>>((ref) {
  return ref.watch(bookmarkRepositoryProvider).all();
});

final earnedBadgesProvider = FutureProvider<Set<String>>((ref) {
  return ref.watch(badgeRepositoryProvider).earnedCodes();
});
