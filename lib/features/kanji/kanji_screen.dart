import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/badge.dart';
import '../../data/models/card_progress.dart';
import '../../data/models/kanji.dart';
import '../../data/providers.dart';
import '../../theme/app_theme.dart';
import '../card_deck/deck_browse_view.dart';
import '../card_deck/deck_card.dart';
import '../card_deck/deck_flashcard_view.dart';
import '../card_deck/deck_quiz_view.dart';
import 'kanji_detail_screen.dart';
import 'kanji_radicals_view.dart';

class KanjiScreen extends ConsumerWidget {
  const KanjiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiAsync = ref.watch(kanjiListProvider);
    final progressAsync = ref.watch(kanjiProgressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kanji')),
      body: kanjiAsync.when(
        data:
            (kanji) => progressAsync.when(
              data: (progress) => _Content(kanji: kanji, progress: progress),
              loading:
                  () => const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  ),
              error: (error, _) => _Err(error: error),
            ),
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            ),
        error: (error, _) => _Err(error: error),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  final List<Kanji> kanji;
  final Map<int, CardProgress> progress;
  const _Content({required this.kanji, required this.progress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards =
        kanji
            .where((k) => k.id != null)
            .map(
              (k) => DeckCard(
                id: k.id!,
                front: k.character,
                back: k.meaning,
                subtitle: _readingLine(k),
                meta: '${k.strokes} strokes · ${k.level}',
              ),
            )
            .toList();

    Future<void> review(DeckCard card, bool correct) async {
      final current =
          progress[card.id] ??
          CardProgress.initial(
            deck: CardProgress.deckKanji,
            itemId: card.id,
            now: DateTime.now(),
          );
      await ref
          .read(cardProgressRepositoryProvider)
          .save(current.review(correct: correct, now: DateTime.now()));
      final granted = await ref
          .read(lessonRecorderProvider)
          .recordReview(xpEarned: correct ? 7 : 1);
      ref.invalidate(kanjiProgressProvider);
      ref.invalidate(userProgressProvider);
      ref.invalidate(reviewDueCountProvider);
      ref.invalidate(earnedBadgesProvider);
      if (granted.isNotEmpty && context.mounted) {
        for (final code in granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.ink,
              content: Text(
                'Badge unlocked: ${BadgeCatalog.byCode(code).title}',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            labelColor: AppColors.ink,
            unselectedLabelColor: AppColors.inkMuted,
            indicatorColor: AppColors.accent,
            tabs: [
              Tab(text: 'Browse'),
              Tab(text: 'Radicals'),
              Tab(text: 'Flashcards'),
              Tab(text: 'Quiz'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                DeckBrowseView(
                  cards: cards,
                  progress: progress,
                  onTap: (card) {
                    final match = kanji.firstWhere((k) => k.id == card.id);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => KanjiDetailScreen(kanji: match),
                      ),
                    );
                  },
                ),
                KanjiRadicalsView(kanji: kanji),
                DeckFlashcardView(
                  cards: cards,
                  progress: progress,
                  onReview: review,
                ),
                DeckQuizView(
                  promptLabel: 'Choose the meaning',
                  cards: cards,
                  onReview: review,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _readingLine(Kanji k) {
    final parts = <String>[];
    if (k.onyomi.isNotEmpty) parts.add('音: ${k.onyomi}');
    if (k.kunyomi.isNotEmpty) parts.add('訓: ${k.kunyomi}');
    return parts.join('  ·  ');
  }
}

class _Err extends StatelessWidget {
  final Object error;
  const _Err({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Could not load kanji:\n$error',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.danger,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
