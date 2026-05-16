import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Demo state — wired to real data later.
  final int _xp = 120;
  final int _streak = 3;
  final int _modulesDone = 0;
  final int _modulesTotal = 4;
  final int _dayNumber = 3;
  final int _todayDone = 2;
  final int _todayTotal = 5;
  // ● = studied, ○ = not yet, today is index 2 (Wed)
  final List<bool> _week = const [true, true, false, false, false, false, false];
  final int _todayWeekIndex = 2;

  // Goal mock
  final String _goalLevel = 'JLPT N5';
  final String _goalTarget = 'Aug 2026';
  final int _goalDayCurrent = 12;
  final int _goalDayTotal = 90;

  // Review queue mock (set to 0 to hide the section)
  final int _reviewDue = 12;

  // Recent activity mock
  final List<_Activity> _recent = const [
    _Activity(title: 'Hiragana  あ–お', xp: 25, when: '2h ago'),
    _Activity(title: 'Hiragana  か–こ', xp: 25, when: 'yesterday'),
    _Activity(title: 'Daily quiz', xp: 10, when: '2 days ago'),
  ];

  void _startDaily() {
    HapticFeedback.lightImpact();
    // TODO: route into today's lesson.
  }

  void _startReview() {
    HapticFeedback.lightImpact();
    // TODO: route into SRS review.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            _Greeting(dayNumber: _dayNumber),
            const SizedBox(height: 28),
            _HeroStats(xp: _xp, streak: _streak, done: _modulesDone, total: _modulesTotal),
            const SizedBox(height: 28),
            _DailyHero(done: _todayDone, total: _todayTotal, onTap: _startDaily),
            const SizedBox(height: 36),
            const _SectionLabel('This week'),
            const SizedBox(height: 14),
            _WeekStrip(days: _week, todayIndex: _todayWeekIndex),
            const SizedBox(height: 36),
            const _SectionLabel('Goal'),
            const SizedBox(height: 12),
            _GoalCard(
              level: _goalLevel,
              target: _goalTarget,
              dayCurrent: _goalDayCurrent,
              dayTotal: _goalDayTotal,
            ),
            if (_reviewDue > 0) ...[
              const SizedBox(height: 28),
              const _SectionLabel('Review'),
              const SizedBox(height: 12),
              _ReviewCard(due: _reviewDue, onTap: _startReview),
            ],
            const SizedBox(height: 28),
            const _SectionLabel('Recent'),
            const SizedBox(height: 4),
            ..._recent.map((a) => _ActivityRow(activity: a)),
          ],
        ),
      ),
    );
  }
}

class _Activity {
  final String title;
  final int xp;
  final String when;
  const _Activity({required this.title, required this.xp, required this.when});
}

class _Greeting extends StatelessWidget {
  final int dayNumber;
  const _Greeting({required this.dayNumber});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DAY $dayNumber',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.inkMuted,
            letterSpacing: 1.4,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'おかえり。',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
            letterSpacing: -1,
            height: 1.1,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 320.ms).slideY(begin: 0.04, end: 0, duration: 380.ms, curve: Curves.easeOutCubic);
  }
}

class _HeroStats extends StatelessWidget {
  final int xp;
  final int streak;
  final int done;
  final int total;
  const _HeroStats({required this.xp, required this.streak, required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _BigStat(value: '$xp', label: 'XP', emphasis: true)),
        const _StatDivider(),
        Expanded(
          child: _BigStat(
            value: '$streak',
            label: 'STREAK',
            trailing: const Text('🔥', style: TextStyle(fontSize: 22))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.15, 1.15),
                  duration: 900.ms,
                  curve: Curves.easeInOut,
                ),
          ),
        ),
        const _StatDivider(),
        Expanded(child: _BigStat(value: '$done/$total', label: 'MODULES')),
      ],
    ).animate(delay: 80.ms).fadeIn(duration: 350.ms).slideY(begin: 0.04, end: 0, duration: 400.ms);
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 44,
      color: AppColors.hairline,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _BigStat extends StatelessWidget {
  final String value;
  final String label;
  final bool emphasis;
  final Widget? trailing;
  const _BigStat({required this.value, required this.label, this.emphasis = false, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.2,
                  color: emphasis ? AppColors.accent : AppColors.ink,
                  height: 1,
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 6),
              Padding(padding: const EdgeInsets.only(bottom: 2), child: trailing),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _DailyHero extends StatelessWidget {
  final int done;
  final int total;
  final VoidCallback onTap;
  const _DailyHero({required this.done, required this.total, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : done / total;
    final ctaLabel = done == 0 ? 'Start' : 'Continue';

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TODAY',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                '$done / $total',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Learn 5 hiragana',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 16),
          _HeroProgressBar(progress: progress),
          const SizedBox(height: 18),
          _HeroCta(label: ctaLabel, onTap: onTap),
        ],
      ),
    ).animate(delay: 160.ms).fadeIn(duration: 350.ms).slideY(begin: 0.06, end: 0, duration: 450.ms, curve: Curves.easeOutCubic);
  }
}

class _HeroProgressBar extends StatelessWidget {
  final double progress;
  const _HeroProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Stack(
        children: [
          Container(height: 8, color: Colors.white.withValues(alpha: 0.25)),
          LayoutBuilder(
            builder: (_, c) => TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (_, v, __) => Container(
                height: 8,
                width: c.maxWidth * v,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCta extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _HeroCta({required this.label, required this.onTap});

  @override
  State<_HeroCta> createState() => _HeroCtaState();
}

class _HeroCtaState extends State<_HeroCta> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) {
        setState(() => _down = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _down ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  color: AppColors.accentDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.accentDark),
            ],
          ),
        ),
      ),
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

class _WeekStrip extends StatelessWidget {
  final List<bool> days;
  final int todayIndex;
  const _WeekStrip({required this.days, required this.todayIndex});

  static const _labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(days.length, (i) {
        final studied = days[i];
        final isToday = i == todayIndex;
        return Expanded(
          child: Column(
            children: [
              Text(
                _labels[i],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isToday ? AppColors.ink : AppColors.inkMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              _WeekDot(studied: studied, isToday: isToday),
            ],
          ),
        );
      }),
    ).animate(delay: 240.ms).fadeIn(duration: 350.ms);
  }
}

class _WeekDot extends StatelessWidget {
  final bool studied;
  final bool isToday;
  const _WeekDot({required this.studied, required this.isToday});

  @override
  Widget build(BuildContext context) {
    final size = isToday ? 14.0 : 10.0;
    final color = studied
        ? AppColors.accent
        : (isToday ? AppColors.accentTint : AppColors.hairline);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isToday && !studied
            ? Border.all(color: AppColors.accent, width: 2)
            : null,
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String level;
  final String target;
  final int dayCurrent;
  final int dayTotal;
  const _GoalCard({
    required this.level,
    required this.target,
    required this.dayCurrent,
    required this.dayTotal,
  });

  static const _stages = [
    _Stage('Hiragana basics', _StageStatus.done),
    _Stage('Hiragana full', _StageStatus.current),
    _Stage('Katakana', _StageStatus.upcoming),
    _Stage('Kanji N5', _StageStatus.upcoming),
    _Stage('Vocab + grammar', _StageStatus.upcoming),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = _stages.indexWhere((s) => s.status == _StageStatus.current);
    final current = _stages[currentIndex];
    final next = currentIndex + 1 < _stages.length ? _stages[currentIndex + 1] : null;
    final progress = dayCurrent / dayTotal;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                level,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: AppColors.ink,
                ),
              ),
              Text(
                'target $target',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'STAGE ${currentIndex + 1} OF ${_stages.length}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            current.label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: AppColors.ink,
            ),
          ),
          if (next != null) ...[
            const SizedBox(height: 4),
            Text(
              'Up next  ·  ${next.label}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.inkMuted,
              ),
            ),
          ],
          const SizedBox(height: 18),
          const _StagePath(stages: _stages),
          const SizedBox(height: 18),
          _GoalProgressBar(progress: progress),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Day $dayCurrent of $dayTotal',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkSoft,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: 280.ms).fadeIn(duration: 350.ms).slideY(begin: 0.04, end: 0, duration: 400.ms, curve: Curves.easeOutCubic);
  }
}

enum _StageStatus { done, current, upcoming }

class _Stage {
  final String label;
  final _StageStatus status;
  const _Stage(this.label, this.status);
}

class _StagePath extends StatelessWidget {
  final List<_Stage> stages;
  const _StagePath({required this.stages});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 14,
      child: Row(
        children: List.generate(stages.length * 2 - 1, (i) {
          if (i.isOdd) {
            final leftDone = stages[i ~/ 2].status == _StageStatus.done;
            final rightDone = stages[i ~/ 2 + 1].status != _StageStatus.upcoming;
            return Expanded(
              child: Container(
                height: 2,
                color: (leftDone && rightDone) ? AppColors.accent : AppColors.hairline,
              ),
            );
          }
          final stage = stages[i ~/ 2];
          return _StageNode(status: stage.status);
        }),
      ),
    );
  }
}

class _StageNode extends StatelessWidget {
  final _StageStatus status;
  const _StageNode({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case _StageStatus.done:
        return Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
        );
      case _StageStatus.current:
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.35),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      case _StageStatus.upcoming:
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.bg,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.hairline, width: 2),
          ),
        );
    }
  }
}

class _GoalProgressBar extends StatelessWidget {
  final double progress;
  const _GoalProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Stack(
        children: [
          Container(height: 6, color: AppColors.hairline),
          LayoutBuilder(
            builder: (_, c) => TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress.clamp(0, 1)),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (_, v, __) => Container(
                height: 6,
                width: c.maxWidth * v,
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatefulWidget {
  final int due;
  final VoidCallback onTap;
  const _ReviewCard({required this.due, required this.onTap});

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) {
        setState(() => _down = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _down ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
          decoration: BoxDecoration(
            color: AppColors.accentTint,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Text(
                '${widget.due}',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.2,
                  color: AppColors.accentDark,
                  height: 1,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'cards due',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'review now to keep your streak',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: 320.ms).fadeIn(duration: 350.ms).slideY(begin: 0.04, end: 0, duration: 400.ms);
  }
}

class _ActivityRow extends StatelessWidget {
  final _Activity activity;
  const _ActivityRow({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.tintSage,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.check_rounded, size: 16, color: AppColors.success),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              activity.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                letterSpacing: -0.2,
              ),
            ),
          ),
          Text(
            '+${activity.xp} XP',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.accent,
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 64,
            child: Text(
              activity.when,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.inkMuted,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 360.ms, duration: 320.ms);
  }
}
