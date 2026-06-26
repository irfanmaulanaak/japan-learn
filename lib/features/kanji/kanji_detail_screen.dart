import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models/kanji.dart';
import '../../data/models/vocabulary.dart';
import '../../data/radical_glossary.dart';
import '../../data/seed/vocabulary_seed.dart';
import '../../shared/speak_button.dart';
import '../../theme/app_theme.dart';

/// Detail page for a single kanji. Turns the radical browser from a dead-end
/// grid into something teachable: shows the meaning, readings, the component
/// parts (with what each part means), and real words that use the kanji — each
/// with audio.
class KanjiDetailScreen extends StatelessWidget {
  final Kanji kanji;
  const KanjiDetailScreen({super.key, required this.kanji});

  @override
  Widget build(BuildContext context) {
    final examples =
        vocabularySeedData
            .where((v) => v.word.contains(kanji.character))
            .take(10)
            .toList();

    return Scaffold(
      appBar: AppBar(title: Text(kanji.character)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        children: [
          _Hero(kanji: kanji).animate().fadeIn(duration: 240.ms),
          const SizedBox(height: 24),
          const _SectionLabel('Built from'),
          const SizedBox(height: 10),
          _Components(kanji: kanji),
          if (examples.isNotEmpty) ...[
            const SizedBox(height: 26),
            const _SectionLabel('Appears in'),
            const SizedBox(height: 8),
            ...examples.map((v) => _WordRow(word: v)),
          ],
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final Kanji kanji;
  const _Hero({required this.kanji});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            kanji.character,
            style: const TextStyle(
              fontSize: 104,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          SpeakButton(text: kanji.character, size: 24),
          const SizedBox(height: 12),
          Text(
            kanji.meaning,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              if (kanji.onyomi.isNotEmpty)
                _ReadingChip(label: '音', value: kanji.onyomi),
              if (kanji.kunyomi.isNotEmpty)
                _ReadingChip(label: '訓', value: kanji.kunyomi),
              _ReadingChip(label: '画', value: '${kanji.strokes} strokes'),
              _ReadingChip(label: 'JLPT', value: kanji.level),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReadingChip extends StatelessWidget {
  final String label;
  final String value;
  const _ReadingChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label  ',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.inkMuted,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Components extends StatelessWidget {
  final Kanji kanji;
  const _Components({required this.kanji});

  @override
  Widget build(BuildContext context) {
    final parts = kanji.radicalList;
    if (parts.isEmpty) {
      return const Text(
        'No component breakdown available.',
        style: TextStyle(
          color: AppColors.inkMuted,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    return Column(
      children:
          parts.map((r) {
            final meaning = radicalMeaning(r);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.tintSage,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      r,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      meaning ?? 'component',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}

class _WordRow extends StatelessWidget {
  final Vocabulary word;
  const _WordRow({required this.word});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${word.word}  ·  ${word.reading}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  word.meaning,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SpeakButton(text: word.word, size: 18, background: AppColors.surface),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: AppColors.inkMuted,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
      ),
    );
  }
}
