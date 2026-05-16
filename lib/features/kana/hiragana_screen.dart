import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/kana.dart';
import '../../data/models/kana_progress.dart';
import '../../data/providers.dart';
import '../../theme/app_theme.dart';
import 'hiragana_browse_view.dart';
import 'hiragana_flashcard_view.dart';
import 'hiragana_quiz_view.dart';

class HiraganaScreen extends ConsumerWidget {
  const HiraganaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanaAsync = ref.watch(hiraganaListProvider);
    final progressAsync = ref.watch(hiraganaProgressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Hiragana')),
      body: kanaAsync.when(
        data:
            (kana) => progressAsync.when(
              data:
                  (progress) =>
                      _HiraganaContent(kana: kana, progress: progress),
              loading: () => const _LoadingState(),
              error: (error, _) => _ErrorState(error: error),
            ),
        loading: () => const _LoadingState(),
        error: (error, _) => _ErrorState(error: error),
      ),
    );
  }
}

class _HiraganaContent extends ConsumerWidget {
  final List<Kana> kana;
  final Map<int, KanaProgress> progress;
  const _HiraganaContent({required this.kana, required this.progress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();

    Future<void> recordReview(Kana item, bool correct) async {
      final id = item.id;
      if (id == null) return;

      final current =
          progress[id] ?? KanaProgress.initial(kanaId: id, now: now);
      await ref
          .read(kanaProgressRepositoryProvider)
          .save(current.review(correct: correct, now: DateTime.now()));
      await ref
          .read(userProgressRepositoryProvider)
          .recordStudy(xpEarned: correct ? 5 : 1);
      ref.invalidate(hiraganaProgressProvider);
      ref.invalidate(userProgressProvider);
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
                HiraganaBrowseView(kana: kana, progress: progress),
                HiraganaFlashcardView(
                  kana: kana,
                  progress: progress,
                  onReview: recordReview,
                ),
                HiraganaQuizView(kana: kana, onReview: recordReview),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.accent),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final Object error;
  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Could not load hiragana:\n$error',
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
