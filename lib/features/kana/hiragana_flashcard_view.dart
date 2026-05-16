import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models/kana.dart';
import '../../data/models/kana_progress.dart';
import '../../theme/app_theme.dart';

class HiraganaFlashcardView extends StatefulWidget {
  final List<Kana> kana;
  final Map<int, KanaProgress> progress;
  final Future<void> Function(Kana item, bool correct) onReview;
  const HiraganaFlashcardView({
    super.key,
    required this.kana,
    required this.progress,
    required this.onReview,
  });

  @override
  State<HiraganaFlashcardView> createState() => _HiraganaFlashcardViewState();
}

class _HiraganaFlashcardViewState extends State<HiraganaFlashcardView> {
  int _index = 0;
  bool _revealed = false;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    if (widget.kana.isEmpty) return const SizedBox.shrink();

    final deck = _deck();
    final item = deck[_index % deck.length];

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
      children: [
        Text(
          '${_index + 1} / ${deck.length}',
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _saving ? null : () => setState(() => _revealed = true),
          child: Container(
            height: 280,
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
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.character,
                  style: const TextStyle(
                    fontSize: 92,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  _revealed ? item.romaji : 'tap to reveal',
                  style: TextStyle(
                    fontSize: _revealed ? 28 : 15,
                    fontWeight: FontWeight.w800,
                    color: _revealed ? AppColors.accent : AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.03, end: 0),
        const SizedBox(height: 18),
        if (_revealed)
          Row(
            children: [
              Expanded(
                child: _AnswerButton(
                  label: 'Again',
                  color: AppColors.hairline,
                  textColor: AppColors.ink,
                  onTap:
                      _saving ? null : () => _answer(item, false, deck.length),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AnswerButton(
                  label: 'Know it',
                  color: AppColors.accent,
                  textColor: Colors.white,
                  onTap:
                      _saving ? null : () => _answer(item, true, deck.length),
                ),
              ),
            ],
          )
        else
          _AnswerButton(
            label: 'Reveal',
            color: AppColors.accent,
            textColor: Colors.white,
            onTap: _saving ? null : () => setState(() => _revealed = true),
          ),
      ],
    );
  }

  List<Kana> _deck() {
    final now = DateTime.now();
    final due =
        widget.kana.where((item) {
          final id = item.id;
          if (id == null) return false;
          final p =
              widget.progress[id] ?? KanaProgress.initial(kanaId: id, now: now);
          return p.isDue(now);
        }).toList();
    return due.isEmpty ? widget.kana : due;
  }

  Future<void> _answer(Kana item, bool correct, int deckLength) async {
    setState(() => _saving = true);
    HapticFeedback.lightImpact();
    await widget.onReview(item, correct);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _revealed = false;
      _index = (_index + 1) % deckLength;
    });
  }
}

class _AnswerButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback? onTap;
  const _AnswerButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        disabledBackgroundColor: AppColors.hairline,
        disabledForegroundColor: AppColors.inkMuted,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}
