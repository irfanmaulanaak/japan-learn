import 'package:japan_learn/data/database/database_helper.dart';
import 'package:japan_learn/data/models/bookmark.dart';
import 'package:japan_learn/data/models/card_progress.dart';
import 'package:japan_learn/data/models/kana.dart';
import 'package:japan_learn/data/models/kana_progress.dart';
import 'package:japan_learn/data/models/kanji.dart';
import 'package:japan_learn/data/models/user_goal.dart';
import 'package:japan_learn/data/models/user_progress.dart';
import 'package:japan_learn/data/models/vocabulary.dart';
import 'package:japan_learn/data/repositories/badge_repository.dart';
import 'package:japan_learn/data/repositories/bookmark_repository.dart';
import 'package:japan_learn/data/repositories/card_progress_repository.dart';
import 'package:japan_learn/data/repositories/kana_progress_repository.dart';
import 'package:japan_learn/data/repositories/kana_repository.dart';
import 'package:japan_learn/data/repositories/kanji_repository.dart';
import 'package:japan_learn/data/repositories/user_goal_repository.dart';
import 'package:japan_learn/data/repositories/user_progress_repository.dart';
import 'package:japan_learn/data/repositories/vocabulary_repository.dart';

// All fakes share the same DatabaseHelper instance because the real repos
// take it in their constructor — but no fake actually touches it.

class FakeUserGoalRepository extends UserGoalRepository {
  FakeUserGoalRepository([UserGoal? goal])
      : _goal = goal,
        super(DatabaseHelper.instance);
  UserGoal? _goal;
  @override
  Future<UserGoal?> current() async => _goal;
  @override
  Future<void> save(UserGoal goal) async => _goal = goal;
}

class FakeUserProgressRepository extends UserProgressRepository {
  FakeUserProgressRepository([UserProgress? progress])
      : _progress = progress ?? UserProgress.initial(now: DateTime.utc(2026, 1)),
        super(DatabaseHelper.instance);
  UserProgress _progress;
  @override
  Future<UserProgress> currentOrCreate() async => _progress;
  @override
  Future<void> save(UserProgress progress) async => _progress = progress;
  @override
  Future<UserProgress> recordStudy({required int xpEarned}) async {
    _progress = _progress.recordStudy(
      now: DateTime.now(),
      xpEarned: xpEarned,
    );
    return _progress;
  }
}

class FakeKanaRepository extends KanaRepository {
  FakeKanaRepository({List<Kana>? hiragana, List<Kana>? katakana})
      : _hira = hiragana ?? _defaultHira(),
        _kata = katakana ?? _defaultKata(),
        super(DatabaseHelper.instance);
  final List<Kana> _hira;
  final List<Kana> _kata;
  @override
  Future<List<Kana>> all({String? type}) async {
    if (type == Kana.typeHiragana) return _hira;
    if (type == Kana.typeKatakana) return _kata;
    return [..._hira, ..._kata];
  }

  @override
  Future<List<Kana>> byRow(String type, String rowGroup) async =>
      (await all(type: type))
          .where((k) => k.rowGroup == rowGroup)
          .toList();

  static List<Kana> _defaultHira() => List.generate(
        46,
        (i) => Kana(
          id: i + 1,
          character: 'あ',
          romaji: 'a',
          type: Kana.typeHiragana,
          rowGroup: 'a',
          orderIndex: i,
        ),
      );

  static List<Kana> _defaultKata() => List.generate(
        46,
        (i) => Kana(
          id: 100 + i,
          character: 'ア',
          romaji: 'a',
          type: Kana.typeKatakana,
          rowGroup: 'a',
          orderIndex: i,
        ),
      );
}

class FakeKanaProgressRepository extends KanaProgressRepository {
  FakeKanaProgressRepository([Map<int, KanaProgress>? store])
      : _store = store ?? {},
        super(DatabaseHelper.instance);
  final Map<int, KanaProgress> _store;
  @override
  Future<Map<int, KanaProgress>> byKanaIds(List<int> ids) async =>
      {for (final id in ids) if (_store.containsKey(id)) id: _store[id]!};
  @override
  Future<void> save(KanaProgress p) async => _store[p.kanaId] = p;
}

class FakeVocabularyRepository extends VocabularyRepository {
  FakeVocabularyRepository([List<Vocabulary>? items])
      : _items = items ?? _defaults(),
        super(DatabaseHelper.instance);
  final List<Vocabulary> _items;
  @override
  Future<List<Vocabulary>> all() async => _items;
  @override
  Future<List<Vocabulary>> byLevel(String level) async =>
      _items.where((v) => v.level == level).toList();
  @override
  Future<List<Vocabulary>> search(String query) async => _items
      .where(
        (v) =>
            v.word.contains(query) ||
            v.meaning.toLowerCase().contains(query.toLowerCase()),
      )
      .toList();
  @override
  Future<Vocabulary?> byId(int id) async =>
      _items.where((v) => v.id == id).cast<Vocabulary?>().firstWhere(
            (e) => e != null,
            orElse: () => null,
          );

  static List<Vocabulary> _defaults() => List.generate(
        12,
        (i) => Vocabulary(
          id: i + 1,
          word: '猫',
          reading: 'ねこ',
          meaning: 'cat',
          partOfSpeech: 'noun',
          level: 'N5',
          exampleJa: '猫が好きです。',
          exampleEn: 'I like cats.',
        ),
      );
}

class FakeKanjiRepository extends KanjiRepository {
  FakeKanjiRepository([List<Kanji>? items])
      : _items = items ?? _defaults(),
        super(DatabaseHelper.instance);
  final List<Kanji> _items;
  @override
  Future<List<Kanji>> all() async => _items;
  @override
  Future<List<Kanji>> byLevel(String level) async =>
      _items.where((k) => k.level == level).toList();
  @override
  Future<List<Kanji>> search(String query) async => _items
      .where(
        (k) =>
            k.character.contains(query) ||
            k.meaning.toLowerCase().contains(query.toLowerCase()),
      )
      .toList();
  @override
  Future<List<Kanji>> byRadical(String radical) async =>
      _items.where((k) => k.radicals.contains(radical)).toList();
  @override
  Future<Kanji?> byId(int id) async =>
      _items.where((k) => k.id == id).cast<Kanji?>().firstWhere(
            (e) => e != null,
            orElse: () => null,
          );

  static List<Kanji> _defaults() => List.generate(
        12,
        (i) => Kanji(
          id: i + 1,
          character: '日',
          meaning: 'day; sun',
          onyomi: 'ニチ',
          kunyomi: 'ひ',
          radicals: '日',
          strokes: 4,
          level: 'N5',
        ),
      );
}

class FakeCardProgressRepository extends CardProgressRepository {
  FakeCardProgressRepository() : super(DatabaseHelper.instance);
  final _store = <String, CardProgress>{};
  String _key(String deck, int id) => '$deck:$id';
  @override
  Future<Map<int, CardProgress>> byDeckIds({
    required String deck,
    required List<int> itemIds,
  }) async {
    return {
      for (final id in itemIds)
        if (_store.containsKey(_key(deck, id))) id: _store[_key(deck, id)]!,
    };
  }

  @override
  Future<void> save(CardProgress p) async =>
      _store[_key(p.deck, p.itemId)] = p;
  @override
  Future<int> dueCount({required String deck, required DateTime now}) async =>
      0;
  @override
  Future<int> masteredCount(String deck) async => 0;
}

class FakeBookmarkRepository extends BookmarkRepository {
  FakeBookmarkRepository() : super(DatabaseHelper.instance);
  final _store = <String, Bookmark>{};
  String _key(String kind, int id) => '$kind:$id';
  @override
  Future<List<Bookmark>> all() async => _store.values.toList();
  @override
  Future<bool> exists({required String kind, required int itemId}) async =>
      _store.containsKey(_key(kind, itemId));
  @override
  Future<void> toggle({required String kind, required int itemId}) async {
    final key = _key(kind, itemId);
    if (_store.containsKey(key)) {
      _store.remove(key);
      return;
    }
    _store[key] = Bookmark(
      kind: kind,
      itemId: itemId,
      createdAt: DateTime.now(),
    );
  }
}

class FakeBadgeRepository extends BadgeRepository {
  FakeBadgeRepository([Set<String>? earned])
      : _earned = earned ?? <String>{},
        super(DatabaseHelper.instance);
  final Set<String> _earned;
  @override
  Future<Set<String>> earnedCodes() async => Set.of(_earned);
  @override
  Future<bool> grant(String code) async => _earned.add(code);
}
