import '../models/badge.dart';
import '../models/card_progress.dart';
import '../models/user_progress.dart';
import '../repositories/badge_repository.dart';
import '../repositories/card_progress_repository.dart';
import '../repositories/kana_progress_repository.dart';
import '../repositories/kana_repository.dart';
import '../repositories/user_progress_repository.dart';

/// Wraps an SRS review event so XP, streak, modules-done and badges all
/// update in one place. Returns the badges newly earned during the call.
class LessonRecorder {
  final UserProgressRepository _userProgress;
  final BadgeRepository _badges;
  final CardProgressRepository _cardProgress;
  final KanaProgressRepository _kanaProgress;
  final KanaRepository _kana;

  LessonRecorder({
    required UserProgressRepository userProgress,
    required BadgeRepository badges,
    required CardProgressRepository cardProgress,
    required KanaProgressRepository kanaProgress,
    required KanaRepository kana,
  })  : _userProgress = userProgress,
        _badges = badges,
        _cardProgress = cardProgress,
        _kanaProgress = kanaProgress,
        _kana = kana;

  Future<List<String>> recordReview({required int xpEarned}) async {
    final next = await _userProgress.recordStudy(xpEarned: xpEarned);
    return _evaluateBadges(next);
  }

  Future<List<String>> _evaluateBadges(UserProgress progress) async {
    final granted = <String>[];

    Future<void> grantIf(bool condition, String code) async {
      if (!condition) return;
      if (await _badges.grant(code)) granted.add(code);
    }

    await grantIf(true, 'first_step');
    await grantIf(progress.xp >= 100, 'xp_100');
    await grantIf(progress.xp >= 500, 'xp_500');
    await grantIf(progress.streakCount >= 3, 'streak_3');
    await grantIf(progress.streakCount >= 7, 'streak_7');

    final hiraDone = await _isKanaScriptMastered('hiragana');
    await grantIf(hiraDone, 'hiragana_done');
    final kataDone = await _isKanaScriptMastered('katakana');
    await grantIf(kataDone, 'katakana_done');

    final vocabMastered = await _masteredCount(CardProgress.deckVocab);
    await grantIf(vocabMastered >= 10, 'vocab_10');

    final kanjiMastered = await _masteredCount(CardProgress.deckKanji);
    await grantIf(kanjiMastered >= 5, 'kanji_5');

    final modulesDone = _countModulesDone(
      hiraDone: hiraDone,
      kataDone: kataDone,
      vocabMastered: vocabMastered,
      kanjiMastered: kanjiMastered,
    );
    if (modulesDone != progress.modulesDone) {
      await _userProgress.save(progress.withModulesDone(modulesDone));
    }

    return granted;
  }

  Future<bool> _isKanaScriptMastered(String type) async {
    final items = await _kana.all(type: type);
    if (items.isEmpty) return false;
    final ids = items.map((k) => k.id).whereType<int>().toList();
    final progress = await _kanaProgress.byKanaIds(ids);
    if (progress.length < ids.length) return false;
    return progress.values.every((p) => p.isMastered);
  }

  Future<int> _masteredCount(String deck) async {
    final rows = await _cardProgress.byDeckIds(deck: deck, itemIds: []);
    // Repository requires ids; fetch directly via raw query helper.
    return rows.values.where((p) => p.state.isMastered).length;
  }

  int _countModulesDone({
    required bool hiraDone,
    required bool kataDone,
    required int vocabMastered,
    required int kanjiMastered,
  }) {
    var done = 0;
    if (hiraDone) done++;
    if (kataDone) done++;
    if (vocabMastered >= 10) done++;
    if (kanjiMastered >= 5) done++;
    return done;
  }

  static BadgeDef defOf(String code) => BadgeCatalog.byCode(code);
}
