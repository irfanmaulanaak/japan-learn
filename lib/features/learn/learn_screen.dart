import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/kana.dart';
import '../../data/providers.dart';
import '../../data/seed/grammar_seed.dart';
import '../../theme/app_theme.dart';
import '../grammar/grammar_screen.dart';
import '../jlpt_mock/jlpt_mock_screen.dart';
import '../kana/kana_module_screen.dart';
import '../kanji/kanji_screen.dart';
import '../reading/reading_screen.dart';
import '../shadowing/shadowing_screen.dart';
import '../vocabulary/vocabulary_screen.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hira = ref.watch(hiraganaListProvider).maybeWhen(
          data: (l) => l.length,
          orElse: () => 0,
        );
    final kata = ref.watch(katakanaListProvider).maybeWhen(
          data: (l) => l.length,
          orElse: () => 0,
        );
    final vocab = ref.watch(vocabularyListProvider).maybeWhen(
          data: (l) => l.length,
          orElse: () => 0,
        );
    final kanji = ref.watch(kanjiListProvider).maybeWhen(
          data: (l) => l.length,
          orElse: () => 0,
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            const _SectionLabel('Core modules'),
            const SizedBox(height: 12),
            _ModuleRow(
              kanji: 'あ',
              tint: AppColors.accentTint,
              title: 'Hiragana',
              meta: '$hira characters',
              onTap: () => _open(
                context,
                const KanaModuleScreen(type: Kana.typeHiragana),
              ),
            ),
            const _Divider(),
            _ModuleRow(
              kanji: 'ア',
              tint: AppColors.tintSky,
              title: 'Katakana',
              meta: '$kata characters',
              onTap: () => _open(
                context,
                const KanaModuleScreen(type: Kana.typeKatakana),
              ),
            ),
            const _Divider(),
            _ModuleRow(
              kanji: '漢',
              tint: AppColors.tintSage,
              title: 'Kanji',
              meta: '$kanji kanji · by radical',
              onTap: () => _open(context, const KanjiScreen()),
            ),
            const _Divider(),
            _ModuleRow(
              kanji: '語',
              tint: AppColors.tintLavender,
              title: 'Vocabulary',
              meta: '$vocab JLPT-graded words',
              onTap: () => _open(context, const VocabularyScreen()),
            ),
            const _Divider(),
            _ModuleRow(
              kanji: '文',
              tint: AppColors.tintSky,
              title: 'Grammar',
              meta: '${grammarSeed.length} N5 patterns',
              onTap: () => _open(context, const GrammarScreen()),
            ),
            const SizedBox(height: 28),
            const _SectionLabel('Practice'),
            const SizedBox(height: 12),
            _ModuleRow(
              kanji: '読',
              tint: AppColors.tintSage,
              title: 'Reading',
              meta: 'Graded passages',
              onTap: () => _open(context, const ReadingScreen()),
            ),
            const _Divider(),
            _ModuleRow(
              kanji: '話',
              tint: AppColors.accentTint,
              title: 'Shadowing',
              meta: 'Speak it out loud',
              onTap: () => _open(context, const ShadowingScreen()),
            ),
            const _Divider(),
            _ModuleRow(
              kanji: '試',
              tint: AppColors.tintSky,
              title: 'JLPT mock test',
              meta: 'N5 · timed',
              onTap: () => _open(context, const JlptMockScreen()),
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.inkMuted,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppColors.hairline,
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}

class _ModuleRow extends StatelessWidget {
  final String kanji;
  final Color tint;
  final String title;
  final String meta;
  final VoidCallback onTap;
  const _ModuleRow({
    required this.kanji,
    required this.tint,
    required this.title,
    required this.meta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  kanji,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meta,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.inkMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: AppColors.ink,
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 280.ms)
        .slideY(begin: 0.03, end: 0, duration: 320.ms, curve: Curves.easeOutCubic);
  }
}
