import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models/card_progress.dart';
import '../../shared/speak_button.dart';
import '../../theme/app_theme.dart';
import 'deck_card.dart';

class DeckFlashcardView extends StatefulWidget {
  final List<DeckCard> cards;
  final Map<int, CardProgress> progress;
  final Future<void> Function(DeckCard card, bool correct) onReview;
  const DeckFlashcardView({
    super.key,
    required this.cards,
    required this.progress,
    required this.onReview,
  });

  @override
  State<DeckFlashcardView> createState() => _DeckFlashcardViewState();
}

class _DeckFlashcardViewState extends State<DeckFlashcardView> {
  int _index = 0;
  bool _revealed = false;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'No cards yet.',
            style: TextStyle(
              color: AppColors.inkMuted,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

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
            constraints: const BoxConstraints(minHeight: 280),
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
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.front,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    height: 1.1,
                  ),
                ),
                if (item.subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    item.subtitle!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkSoft,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                SpeakButton(text: item.front, size: 22),
                const SizedBox(height: 18),
                Text(
                  _revealed ? item.back : 'tap to reveal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _revealed ? 22 : 14,
                    fontWeight: FontWeight.w800,
                    color: _revealed ? AppColors.accent : AppColors.inkMuted,
                  ),
                ),
                if (_revealed && item.exampleJa != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.exampleJa!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SpeakButton(
                              text: item.exampleJa!,
                              size: 18,
                              background: AppColors.surface,
                            ),
                          ],
                        ),
                        if ((item.exampleEn ?? '').isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.exampleEn!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkSoft,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.03, end: 0),
        const SizedBox(height: 18),
        if (_revealed)
          Row(
            children: [
              Expanded(
                child: _Btn(
                  label: 'Again',
                  color: AppColors.hairline,
                  textColor: AppColors.ink,
                  onTap:
                      _saving ? null : () => _answer(item, false, deck.length),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Btn(
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
          _Btn(
            label: 'Reveal',
            color: AppColors.accent,
            textColor: Colors.white,
            onTap: _saving ? null : () => setState(() => _revealed = true),
          ),
      ],
    );
  }

  List<DeckCard> _deck() {
    final now = DateTime.now();
    final due =
        widget.cards.where((c) {
          final p = widget.progress[c.id];
          return p == null || p.state.isDue(now);
        }).toList();
    return due.isEmpty ? widget.cards : due;
  }

  Future<void> _answer(DeckCard card, bool correct, int deckLength) async {
    setState(() => _saving = true);
    HapticFeedback.lightImpact();
    await widget.onReview(card, correct);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _revealed = false;
      _index = (_index + 1) % deckLength;
    });
  }
}

class _Btn extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback? onTap;
  const _Btn({
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
