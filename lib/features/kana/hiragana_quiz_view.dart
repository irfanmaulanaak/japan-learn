import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models/kana.dart';
import '../../theme/app_theme.dart';

class HiraganaQuizView extends StatefulWidget {
  final List<Kana> kana;
  final Future<void> Function(Kana item, bool correct) onReview;
  const HiraganaQuizView({
    super.key,
    required this.kana,
    required this.onReview,
  });

  @override
  State<HiraganaQuizView> createState() => _HiraganaQuizViewState();
}

class _HiraganaQuizViewState extends State<HiraganaQuizView> {
  int _index = 0;
  String? _selected;
  bool _saving = false;

  bool get _kanaToRomaji => _index.isEven;

  @override
  Widget build(BuildContext context) {
    if (widget.kana.length < 4) return const SizedBox.shrink();

    final item = widget.kana[_index % widget.kana.length];
    final answer = _kanaToRomaji ? item.romaji : item.character;
    final options = _options(item);
    final answered = _selected != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
      children: [
        Text(
          _kanaToRomaji ? 'Choose the romaji' : 'Choose the hiragana',
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 18),
        Text(
              _kanaToRomaji ? item.character : item.romaji,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                height: 1,
              ),
            )
            .animate()
            .fadeIn(duration: 240.ms)
            .scale(begin: const Offset(0.98, 0.98)),
        const SizedBox(height: 24),
        ...options.map(
          (option) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _QuizOption(
              label: option,
              selected: _selected == option,
              correct: answered && option == answer,
              wrong: answered && _selected == option && option != answer,
              onTap:
                  answered || _saving
                      ? null
                      : () => _answer(item, option, option == answer),
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

  List<String> _options(Kana item) {
    final answer = _kanaToRomaji ? item.romaji : item.character;
    final values = <String>[answer];
    var offset = 1;

    while (values.length < 4) {
      final other = widget.kana[(_index + offset) % widget.kana.length];
      final value = _kanaToRomaji ? other.romaji : other.character;
      if (!values.contains(value)) values.add(value);
      offset += 3;
    }

    values.sort();
    return values;
  }

  Future<void> _answer(Kana item, String option, bool correct) async {
    setState(() {
      _saving = true;
      _selected = option;
    });
    HapticFeedback.lightImpact();
    await widget.onReview(item, correct);
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

class _QuizOption extends StatelessWidget {
  final String label;
  final bool selected;
  final bool correct;
  final bool wrong;
  final VoidCallback? onTap;
  const _QuizOption({
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
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
