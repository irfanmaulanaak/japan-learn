import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/kana.dart';
import '../../data/models/kana_progress.dart';
import '../../data/providers.dart';
import '../../theme/app_theme.dart';
import 'kana_browse_view.dart';
import 'kana_flashcard_view.dart';
import 'kana_quiz_view.dart';

class KanaModuleScreen extends ConsumerWidget {
  final String type; // Kana.typeHiragana or Kana.typeKatakana
  const KanaModuleScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHira = type == Kana.typeHiragana;
    final kanaAsync = ref.watch(
      isHira ? hiraganaListProvider : katakanaListProvider,
    );
    final progressAsync = ref.watch(
      isHira ? hiraganaProgressProvider : katakanaProgressProvider,
    );

    return Scaffold(
      appBar: AppBar(title: Text(isHira ? 'Hiragana' : 'Katakana')),
      body: kanaAsync.when(
        data:
            (kana) => progressAsync.when(
              data:
                  (progress) => _Content(
                    type: type,
                    kana: kana,
                    progress: progress,
                  ),
              loading: () => const _LoadingState(),
              error: (error, _) => _ErrorState(error: error),
            ),
        loading: () => const _LoadingState(),
        error: (error, _) => _ErrorState(error: error),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  final String type;
  final List<Kana> kana;
  final Map<int, KanaProgress> progress;
  const _Content({
    required this.type,
    required this.kana,
    required this.progress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final isHira = type == Kana.typeHiragana;

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
      ref.invalidate(
        isHira ? hiraganaProgressProvider : katakanaProgressProvider,
      );
      ref.invalidate(userProgressProvider);
      ref.invalidate(reviewDueCountProvider);
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
                KanaBrowseView(kana: kana, progress: progress),
                KanaFlashcardView(
                  kana: kana,
                  progress: progress,
                  onReview: recordReview,
                ),
                KanaQuizView(type: type, kana: kana, onReview: recordReview),
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
          'Could not load kana:\n$error',
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
