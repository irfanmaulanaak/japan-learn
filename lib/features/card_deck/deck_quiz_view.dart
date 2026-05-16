import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../theme/app_theme.dart';
import 'deck_card.dart';

class DeckQuizView extends StatefulWidget {
  final String promptLabel;
  final List<DeckCard> cards;
  final Future<void> Function(DeckCard card, bool correct) onReview;
  const DeckQuizView({
    super.key,
    required this.promptLabel,
    required this.cards,
    required this.onReview,
  });

  @override
  State<DeckQuizView> createState() => _DeckQuizViewState();
}

class _DeckQuizViewState extends State<DeckQuizView> {
  int _index = 0;
  String? _selected;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    if (widget.cards.length < 4) {
      return const Center(
        child: Text(
          'Need 4+ cards to quiz.',
          style: TextStyle(color: AppColors.inkMuted),
        ),
      );
    }

    final card = widget.cards[_index % widget.cards.length];
    final answer = card.back;
    final options = _options(card);
    final answered = _selected != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
      children: [
        Text(
          widget.promptLabel,
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 18),
        Text(
              card.front,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                height: 1.1,
              ),
            )
            .animate()
            .fadeIn(duration: 240.ms)
            .scale(begin: const Offset(0.98, 0.98)),
        if (card.subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            card.subtitle!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.inkSoft,
            ),
          ),
        ],
        const SizedBox(height: 24),
        ...options.map(
          (option) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _Option(
              label: option,
              selected: _selected == option,
              correct: answered && option == answer,
              wrong: answered && _selected == option && option != answer,
              onTap:
                  answered || _saving
                      ? null
                      : () => _answer(card, option, option == answer),
            ),
          ),
        ),
        if (answered) ...[
          const SizedBox(height: 10),
          FilledButton(
            onPressed: _saving ? null : _next,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Next',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ],
    );
  }

  List<String> _options(DeckCard card) {
    final values = <String>[card.back];
    var offset = 1;
    while (values.length < 4) {
      final other = widget.cards[(_index + offset) % widget.cards.length];
      if (!values.contains(other.back)) values.add(other.back);
      offset += 3;
    }
    values.sort();
    return values;
  }

  Future<void> _answer(DeckCard card, String option, bool correct) async {
    setState(() {
      _saving = true;
      _selected = option;
    });
    HapticFeedback.lightImpact();
    await widget.onReview(card, correct);
    if (!mounted) return;
    setState(() => _saving = false);
  }

  void _next() {
    setState(() {
      _index += 1;
      _selected = null;
    });
  }
}

class _Option extends StatelessWidget {
  final String label;
  final bool selected;
  final bool correct;
  final bool wrong;
  final VoidCallback? onTap;
  const _Option({
    required this.label,
    required this.selected,
    required this.correct,
    required this.wrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        correct
            ? AppColors.tintSage
            : (wrong
                ? AppColors.accentTint
                : (selected ? AppColors.accentTint : AppColors.surface));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.03),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
