import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/badge.dart';
import '../../data/models/card_progress.dart';
import '../../data/models/vocabulary.dart';
import '../../data/providers.dart';
import '../../theme/app_theme.dart';
import '../card_deck/deck_browse_view.dart';
import '../card_deck/deck_card.dart';
import '../card_deck/deck_flashcard_view.dart';
import '../card_deck/deck_quiz_view.dart';

class VocabularyScreen extends ConsumerWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsAsync = ref.watch(vocabularyListProvider);
    final progressAsync = ref.watch(vocabularyProgressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Vocabulary')),
      body: wordsAsync.when(
        data: (words) => progressAsync.when(
          data: (progress) => _Content(words: words, progress: progress),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
          error: (error, _) => _Err(error: error),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (error, _) => _Err(error: error),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  final List<Vocabulary> words;
  final Map<int, CardProgress> progress;
  const _Content({required this.words, required this.progress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = words
        .where((w) => w.id != null)
        .map(
          (w) => DeckCard(
            id: w.id!,
            front: w.word,
            back: w.meaning,
            subtitle: w.reading,
            meta: w.partOfSpeech,
            exampleJa: w.exampleJa,
            exampleEn: w.exampleEn,
          ),
        )
        .toList();

    Future<void> review(DeckCard card, bool correct) async {
      final current = progress[card.id] ??
          CardProgress.initial(
            deck: CardProgress.deckVocab,
            itemId: card.id,
            now: DateTime.now(),
          );
      await ref
          .read(cardProgressRepositoryProvider)
          .save(current.review(correct: correct, now: DateTime.now()));
      final granted = await ref
          .read(lessonRecorderProvider)
          .recordReview(xpEarned: correct ? 6 : 1);
      ref.invalidate(vocabularyProgressProvider);
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
      length: 3,
      child: Column(
        children: [
          const TabBar(
            labelColor: AppColors.ink,
            unselectedLabelColor: AppColors.inkMuted,
            indicatorColor: AppColors.accent,
            tabs: [
              Tab(text: 'Browse'),
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
                  onTap: (_) {},
                ),
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
          'Could not load vocabulary:\n$error',
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
