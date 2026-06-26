import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/seed/grammar_seed.dart';
import '../../shared/speak_button.dart';
import '../../theme/app_theme.dart';

/// Browse N5 grammar points. Tap a point to read the explanation with
/// example sentences (each playable via TTS).
class GrammarScreen extends StatelessWidget {
  const GrammarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final points = grammarSeed.where((g) => g.level == 'N5').toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Grammar')),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          itemCount: points.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final point = points[i];
            return _PointCard(
              point: point,
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => _GrammarDetailScreen(point: point),
                  ),
                );
              },
            ).animate(delay: (i * 20).ms).fadeIn(duration: 240.ms).slideY(
                  begin: 0.04,
                  end: 0,
                  duration: 280.ms,
                  curve: Curves.easeOutCubic,
                );
          },
        ),
      ),
    );
  }
}

class _PointCard extends StatelessWidget {
  final GrammarPoint point;
  final VoidCallback onTap;
  const _PointCard({required this.point, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      point.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _StructurePill(text: point.structure),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StructurePill extends StatelessWidget {
  final String text;
  const _StructurePill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accentTint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppColors.accentDark,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

class _GrammarDetailScreen extends StatelessWidget {
  final GrammarPoint point;
  const _GrammarDetailScreen({required this.point});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grammar')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            Text(
              point.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
                height: 1.2,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            _StructurePill(text: point.structure),
            const SizedBox(height: 18),
            Text(
              point.explanation,
              style: const TextStyle(
                fontSize: 15,
                height: 1.55,
                fontWeight: FontWeight.w600,
                color: AppColors.inkSoft,
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'EXAMPLES',
              style: TextStyle(
                color: AppColors.inkMuted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            ...point.examples.map((e) => _ExampleRow(example: e)),
          ],
        ),
      ),
    );
  }
}

class _ExampleRow extends StatelessWidget {
  final GrammarExample example;
  const _ExampleRow({required this.example});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  example.ja,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  example.en,
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
          SpeakButton(text: example.ja, size: 20),
        ],
      ),
    );
  }
}
