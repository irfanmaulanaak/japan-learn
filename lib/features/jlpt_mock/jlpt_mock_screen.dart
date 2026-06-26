import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../data/seed/quiz_seed.dart';
import '../../theme/app_theme.dart';

class JlptMockScreen extends ConsumerStatefulWidget {
  const JlptMockScreen({super.key});

  @override
  ConsumerState<JlptMockScreen> createState() => _JlptMockScreenState();
}

class _JlptMockScreenState extends ConsumerState<JlptMockScreen> {
  static const _level = 'N5';
  late final List<QuizQuestion> _questions = _buildQuestions();

  int _index = 0;
  int _correct = 0;
  final Map<int, int> _picks = {}; // question index -> chosen index
  bool _finished = false;
  Timer? _timer;
  late Duration _remaining;

  /// Filter to the level, then group into exam sections (vocab → kanji →
  /// grammar → reading) so the mock flows like a real paper.
  List<QuizQuestion> _buildQuestions() {
    final list = quizSeed.where((q) => q.level == _level).toList();
    list.sort((a, b) {
      final sa = quizSectionOrder.indexOf(a.section);
      final sb = quizSectionOrder.indexOf(b.section);
      if (sa != sb) return sa.compareTo(sb);
      return a.id.compareTo(b.id);
    });
    return list;
  }

  @override
  void initState() {
    super.initState();
    // ~30s per question, floored at 5 min so short banks still feel timed.
    _remaining = Duration(seconds: (_questions.length * 30).clamp(300, 1800));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_finished) return;
      if (_remaining.inSeconds <= 0) {
        _finish();
        return;
      }
      setState(() => _remaining -= const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _pick(int choiceIndex) {
    if (_picks.containsKey(_index)) return;
    setState(() {
      _picks[_index] = choiceIndex;
      if (_questions[_index].answerIndex == choiceIndex) _correct++;
    });
  }

  void _next() {
    if (_index >= _questions.length - 1) {
      _finish();
      return;
    }
    setState(() => _index++);
  }

  Future<void> _finish() async {
    if (_finished) return;
    _timer?.cancel();
    setState(() => _finished = true);
    final pct = (_correct / _questions.length * 100).round();
    final xp = 20 + (pct ~/ 5);
    await ref.read(lessonRecorderProvider).recordReview(xpEarned: xp);
    ref.invalidate(userProgressProvider);
    ref.invalidate(earnedBadgesProvider);
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No questions available for this level.')),
      );
    }
    if (_finished) {
      return _Results(
        total: _questions.length,
        correct: _correct,
        sections: _sectionScores(),
        onClose: () => Navigator.of(context).pop(),
      );
    }

    final q = _questions[_index];
    final picked = _picks[_index];

    return Scaffold(
      appBar: AppBar(
        title: const Text('$_level Mock'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 14),
            child: Text(
              _format(_remaining),
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            Text(
              'Q ${_index + 1} / ${_questions.length}  ·  ${q.section.toUpperCase()}',
              style: const TextStyle(
                color: AppColors.inkMuted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              q.prompt,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                letterSpacing: -0.3,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            ...List.generate(q.choices.length, (i) {
              final isPick = picked == i;
              final isAnswer = picked != null && q.answerIndex == i;
              final isWrong = isPick && q.answerIndex != i;
              final color =
                  isAnswer
                      ? AppColors.tintSage
                      : (isWrong
                          ? AppColors.accentTint
                          : (isPick
                              ? AppColors.accentTint
                              : AppColors.surface));
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: picked == null ? () => _pick(i) : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      q.choices[i],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
              );
            }),
            if (picked != null) ...[
              const SizedBox(height: 8),
              Text(
                q.explanation,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkSoft,
                ),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: _next,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _index >= _questions.length - 1 ? 'Finish' : 'Next',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<_SectionScore> _sectionScores() {
    final tally = <String, List<int>>{}; // section -> [correct, total]
    for (var i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final row = tally.putIfAbsent(q.section, () => [0, 0]);
      row[1]++;
      if (_picks[i] == q.answerIndex) row[0]++;
    }
    return quizSectionOrder
        .where(tally.containsKey)
        .map(
          (sec) => _SectionScore(
            name: quizSectionNames[sec] ?? sec,
            correct: tally[sec]![0],
            total: tally[sec]![1],
          ),
        )
        .toList();
  }

  String _format(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _SectionScore {
  final String name;
  final int correct;
  final int total;
  const _SectionScore({
    required this.name,
    required this.correct,
    required this.total,
  });
}

class _Results extends StatelessWidget {
  final int total;
  final int correct;
  final List<_SectionScore> sections;
  final VoidCallback onClose;
  const _Results({
    required this.total,
    required this.correct,
    required this.sections,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0 : (correct / total * 100).round();
    final pass = pct >= 60;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          children: [
            Text(
              pass ? 'PASS' : 'TRY AGAIN',
              style: TextStyle(
                color: pass ? AppColors.success : AppColors.danger,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$correct / $total',
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                letterSpacing: -2,
              ),
            ),
            Text(
              '$pct% correct',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.inkSoft,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'BY SECTION',
              style: TextStyle(
                color: AppColors.inkMuted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            ...sections.map((s) => _SectionRow(score: s)),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: onClose,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionRow extends StatelessWidget {
  final _SectionScore score;
  const _SectionRow({required this.score});

  @override
  Widget build(BuildContext context) {
    final pct = score.total == 0 ? 0.0 : score.correct / score.total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                score.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              Text(
                '${score.correct} / ${score.total}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.inkSoft,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Stack(
              children: [
                Container(height: 6, color: AppColors.hairline),
                LayoutBuilder(
                  builder:
                      (_, c) => Container(
                        height: 6,
                        width: c.maxWidth * pct,
                        color:
                            pct >= 0.6 ? AppColors.success : AppColors.accent,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
