import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/badge.dart';
import '../../data/models/card_progress.dart';
import '../../data/providers.dart';
import '../../theme/app_theme.dart';
import '../card_deck/deck_card.dart';
import '../card_deck/deck_flashcard_view.dart';

/// Mixes due cards across vocab + kanji so a user can clear their queue
/// from one place.
class ReviewHubScreen extends ConsumerWidget {
  const ReviewHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsAsync = ref.watch(vocabularyListProvider);
    final vocabProgressAsync = ref.watch(vocabularyProgressProvider);
    final kanjiAsync = ref.watch(kanjiListProvider);
    final kanjiProgressAsync = ref.watch(kanjiProgressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Review')),
      body: wordsAsync.when(
        data: (words) => vocabProgressAsync.when(
          data: (vp) => kanjiAsync.when(
            data: (kanji) => kanjiProgressAsync.when(
              data: (kp) {
                final now = DateTime.now();
                final cards = <DeckCard>[];
                final deckOf = <int, String>{};
                final lookupVocab = {for (final w in words) w.id: w};
                final lookupKanji = {for (final k in kanji) k.id: k};

                for (final w in words) {
                  final p = vp[w.id];
                  if (w.id != null &&
                      p != null &&
                      !p.state.isNew &&
                      p.state.isDue(now)) {
                    cards.add(
                      DeckCard(
                        id: w.id!,
                        front: w.word,
                        back: w.meaning,
                        subtitle: w.reading,
                        meta: w.partOfSpeech,
                        exampleJa: w.exampleJa,
                        exampleEn: w.exampleEn,
                      ),
                    );
                    deckOf[w.id!] = CardProgress.deckVocab;
                  }
                }
                for (final k in kanji) {
                  final p = kp[k.id];
                  if (k.id != null &&
                      p != null &&
                      !p.state.isNew &&
                      p.state.isDue(now)) {
                    cards.add(
                      DeckCard(
                        id: k.id!,
                        front: k.character,
                        back: k.meaning,
                        subtitle: _readingFor(k.onyomi, k.kunyomi),
                      ),
                    );
                    deckOf[k.id!] = CardProgress.deckKanji;
                  }
                }

                if (cards.isEmpty) {
                  return const _Empty();
                }

                final progressMap = <int, CardProgress>{};
                for (final c in cards) {
                  final deck = deckOf[c.id]!;
                  progressMap[c.id] = deck == CardProgress.deckVocab
                      ? vp[c.id]!
                      : kp[c.id]!;
                }

                Future<void> review(DeckCard card, bool correct) async {
                  final deck = deckOf[card.id]!;
                  final current = progressMap[card.id]!;
                  await ref
                      .read(cardProgressRepositoryProvider)
                      .save(current.review(
                        correct: correct,
                        now: DateTime.now(),
                      ));
                  final xp = correct
                      ? (deck == CardProgress.deckKanji ? 7 : 6)
                      : 1;
                  final granted = await ref
                      .read(lessonRecorderProvider)
                      .recordReview(xpEarned: xp);
                  if (deck == CardProgress.deckVocab) {
                    ref.invalidate(vocabularyProgressProvider);
                  } else {
                    ref.invalidate(kanjiProgressProvider);
                  }
                  ref.invalidate(userProgressProvider);
                  ref.invalidate(reviewDueCountProvider);
                  ref.invalidate(earnedBadgesProvider);
                  if (!context.mounted) return;
                  for (final code in granted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.ink,
                        content: Text(
                          'Badge unlocked: '
                          '${BadgeCatalog.byCode(code).title}',
                        ),
                      ),
                    );
                  }
                }

                // touch lookups so they don't get tree-shaken in debug.
                lookupVocab.length;
                lookupKanji.length;

                return DeckFlashcardView(
                  cards: cards,
                  progress: progressMap,
                  onReview: review,
                );
              },
              loading: () => const _Loading(),
              error: (e, _) => _Err(error: e),
            ),
            loading: () => const _Loading(),
            error: (e, _) => _Err(error: e),
          ),
          loading: () => const _Loading(),
          error: (e, _) => _Err(error: e),
        ),
        loading: () => const _Loading(),
        error: (e, _) => _Err(error: e),
      ),
    );
  }

  String? _readingFor(String on, String kun) {
    final parts = <String>[];
    if (on.isNotEmpty) parts.add('音 $on');
    if (kun.isNotEmpty) parts.add('訓 $kun');
    return parts.isEmpty ? null : parts.join('  ·  ');
  }
}

class _Loading extends StatelessWidget {
  const _Loading();
  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(color: AppColors.accent),
  );
}

class _Err extends StatelessWidget {
  final Object error;
  const _Err({required this.error});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$error',
          style: const TextStyle(color: AppColors.danger)));
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.success,
              size: 56,
            ),
            SizedBox(height: 12),
            Text(
              'Inbox zero.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: AppColors.ink,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Nothing due right now. Come back when SRS schedules more.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.inkMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
