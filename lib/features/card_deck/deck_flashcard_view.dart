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
  bool _reverse =
      false; // false: JP → meaning (recognise); true: meaning → JP (recall)

  void _setReverse(bool value) {
    if (_reverse == value) return;
    setState(() {
      _reverse = value;
      _revealed = false;
    });
  }

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
    final prompt = _reverse ? item.back : item.front;
    final answer = _reverse ? item.front : item.back;

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
        const SizedBox(height: 12),
        Row(
          children: [
            _DirChip(
              label: 'JP → EN',
              selected: !_reverse,
              onTap: () => _setReverse(false),
            ),
            const SizedBox(width: 8),
            _DirChip(
              label: 'EN → JP',
              selected: _reverse,
              onTap: () => _setReverse(true),
            ),
          ],
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
                  prompt,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _reverse ? 30 : 56,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    height: 1.15,
                  ),
                ),
                // Reading belongs with the Japanese word: show under the prompt
                // only when the prompt IS the Japanese word (recognition mode).
                if (!_reverse && item.subtitle != null) ...[
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
                // In recall mode the Japanese word is the hidden answer, so keep
                // the audio button hidden until reveal (it would give it away).
                if (!_reverse) ...[
                  const SizedBox(height: 12),
                  SpeakButton(text: item.front, size: 22),
                ],
                const SizedBox(height: 18),
                if (_revealed) ...[
                  Text(
                    answer,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _reverse ? 40 : 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accent,
                      height: 1.15,
                    ),
                  ),
                  if (_reverse && item.subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      item.subtitle!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ],
                  if (_reverse) ...[
                    const SizedBox(height: 10),
                    SpeakButton(text: item.front, size: 22),
                  ],
                ] else
                  const Text(
                    'tap to reveal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.inkMuted,
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

class _DirChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _DirChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : AppColors.surface,
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
              color: selected ? Colors.white : AppColors.inkSoft,
            ),
          ),
        ),
      ),
    );
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
