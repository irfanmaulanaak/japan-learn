import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models/kana.dart';
import '../../data/models/kana_progress.dart';
import '../../theme/app_theme.dart';

/// Production recall: show the kana, type its romaji. True recall (you produce
/// the answer from memory) instead of recognising it from choices. Romaji is
/// typeable on any keyboard, so no Japanese IME is needed. Auto-graded and fed
/// into the same SRS as the other modes.
class KanaRecallView extends StatefulWidget {
  final List<Kana> kana;
  final Map<int, KanaProgress> progress;
  final Future<void> Function(Kana item, bool correct) onReview;
  const KanaRecallView({
    super.key,
    required this.kana,
    required this.progress,
    required this.onReview,
  });

  @override
  State<KanaRecallView> createState() => _KanaRecallViewState();
}

class _KanaRecallViewState extends State<KanaRecallView> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  int _index = 0;
  bool _saving = false;
  bool? _correct; // null = not checked yet
  Kana? _checked; // item being graded; pinned so it can't shift under feedback

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.kana.isEmpty) return const SizedBox.shrink();

    final deck = _deck();
    final checked = _correct != null;
    // While feedback shows, keep the graded item even though re-grading the SRS
    // (via provider invalidation) reshuffles the due deck.
    final item = checked ? _checked! : deck[_index % deck.length];

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
      children: [
        Text(
          '${_index + 1} / ${deck.length}  ·  TYPE THE ROMAJI',
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 220,
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
          child: Text(
            item.character,
            style: const TextStyle(
              fontSize: 96,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              height: 1,
            ),
          ),
        ).animate(key: ValueKey(item.character)).fadeIn(duration: 220.ms),
        const SizedBox(height: 18),
        TextField(
          controller: _controller,
          focusNode: _focus,
          autofocus: true,
          enabled: !checked && !_saving,
          textAlign: TextAlign.center,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.none,
          onSubmitted: (_) => _check(item),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
            letterSpacing: 2,
          ),
          decoration: InputDecoration(
            hintText: 'romaji',
            filled: true,
            fillColor: AppColors.bg,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 14),
        if (checked) _Feedback(correct: _correct!, romaji: item.romaji),
        if (checked) const SizedBox(height: 14),
        if (!checked)
          _Btn(
            label: 'Check',
            color: AppColors.accent,
            textColor: Colors.white,
            onTap: _saving ? null : () => _check(item),
          )
        else
          _Btn(
            label: 'Next',
            color: AppColors.accent,
            textColor: Colors.white,
            onTap: _saving ? null : () => _next(deck.length),
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

  Future<void> _check(Kana item) async {
    if (_correct != null) return;
    final correct = _matches(_controller.text, item.romaji);
    setState(() {
      _saving = true;
      _correct = correct;
      _checked = item;
    });
    HapticFeedback.lightImpact();
    await widget.onReview(item, correct);
    if (!mounted) return;
    setState(() => _saving = false);
  }

  void _next(int deckLength) {
    setState(() {
      _correct = null;
      _checked = null;
      _controller.clear();
      _index = (_index + 1) % deckLength;
    });
    _focus.requestFocus();
  }

  /// Grades input against the stored romaji, accepting common alternate
  /// spellings (e.g. し → shi/si, を → wo/o, しゃ → sha/sya).
  static bool _matches(String input, String romaji) {
    final cleaned = input.trim().toLowerCase().replaceAll(' ', '');
    if (cleaned.isEmpty) return false;
    final target = romaji.toLowerCase();
    if (cleaned == target) return true;
    return (_romajiAlt[target] ?? const []).contains(cleaned);
  }

  static const Map<String, List<String>> _romajiAlt = {
    'shi': ['si'],
    'chi': ['ti'],
    'tsu': ['tu'],
    'fu': ['hu'],
    'ji': ['zi', 'di'],
    'zu': ['du'],
    'wo': ['o'],
    'n': ['nn'],
    'sha': ['sya'],
    'shu': ['syu'],
    'sho': ['syo'],
    'cha': ['tya', 'cya'],
    'chu': ['tyu', 'cyu'],
    'cho': ['tyo', 'cyo'],
    'ja': ['jya', 'zya'],
    'ju': ['jyu', 'zyu'],
    'jo': ['jyo', 'zyo'],
  };
}

class _Feedback extends StatelessWidget {
  final bool correct;
  final String romaji;
  const _Feedback({required this.correct, required this.romaji});

  @override
  Widget build(BuildContext context) {
    final color = correct ? AppColors.success : AppColors.danger;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: color,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            correct ? 'Correct!' : 'Answer: $romaji',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 180.ms);
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
