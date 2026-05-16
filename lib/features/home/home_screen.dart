import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _xp = 120;
  int _streak = 3;
  int _tapBumpKey = 0;
  _Feedback? _feedback;

  void _gainXp() {
    HapticFeedback.lightImpact();
    setState(() {
      _xp += 10;
      _tapBumpKey++;
    });
  }

  void _bumpStreak() {
    HapticFeedback.mediumImpact();
    setState(() => _streak++);
  }

  void _correct() {
    HapticFeedback.mediumImpact();
    setState(() {
      _xp += 25;
      _feedback = _Feedback.correct;
    });
  }

  void _wrong() {
    HapticFeedback.heavyImpact();
    setState(() => _feedback = _Feedback.wrong);
  }

  @override
  Widget build(BuildContext context) {
    final hiraganaAsync = ref.watch(hiraganaListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Japan Learn'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                _StatRow(
                  xp: _xp,
                  streak: _streak,
                  bumpKey: _tapBumpKey,
                ),
                const SizedBox(height: 20),
                _DailyPlanCard(
                  hiraganaCount: hiraganaAsync.maybeWhen(
                    data: (l) => l.length,
                    orElse: () => 0,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Motion preview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.inkSoft,
                      ),
                ),
                const SizedBox(height: 12),
                _SpringButton(
                  label: '+10 XP (tap me)',
                  color: AppColors.vermillion,
                  onTap: _gainXp,
                ),
                const SizedBox(height: 12),
                _SpringButton(
                  label: 'Bump streak 🔥',
                  color: AppColors.gold,
                  onTap: _bumpStreak,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SpringButton(
                        label: 'Correct ✓',
                        color: AppColors.success,
                        onTap: _correct,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SpringButton(
                        label: 'Wrong ✗',
                        color: AppColors.danger,
                        onTap: _wrong,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (_feedback != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: _FeedbackOverlay(
                    key: ValueKey(_feedback!.id),
                    kind: _feedback!,
                    onDone: () => setState(() => _feedback = null),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final int xp;
  final int streak;
  final int bumpKey;
  const _StatRow({required this.xp, required this.streak, required this.bumpKey});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatChip(
            icon: Icons.bolt_rounded,
            color: AppColors.vermillion,
            label: 'XP',
            value: xp,
            bumpKey: bumpKey,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StreakChip(streak: streak),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int value;
  final int bumpKey;
  const _StatChip({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.bumpKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.inkMuted,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              _RollingNumber(value: value, color: AppColors.ink)
                  .animate(key: ValueKey(bumpKey))
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.15, 1.15),
                    duration: 180.ms,
                    curve: Curves.easeOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.15, 1.15),
                    end: const Offset(1, 1),
                    duration: 220.ms,
                    curve: Curves.elasticOut,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  final int streak;
  const _StreakChip({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 22))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.12, 1.12),
                duration: 900.ms,
                curve: Curves.easeInOut,
              ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'STREAK',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.inkMuted,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              _RollingNumber(value: streak, color: AppColors.ink, suffix: ' days'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RollingNumber extends StatelessWidget {
  final int value;
  final Color color;
  final String suffix;
  const _RollingNumber({required this.value, required this.color, this.suffix = ''});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: value.toDouble(), end: value.toDouble()),
      duration: const Duration(milliseconds: 1),
      builder: (_, v, __) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, anim) => SlideTransition(
          position: Tween(begin: const Offset(0, 0.6), end: Offset.zero).animate(anim),
          child: FadeTransition(opacity: anim, child: child),
        ),
        child: Text(
          '$value$suffix',
          key: ValueKey('$value$suffix'),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _DailyPlanCard extends StatelessWidget {
  final int hiraganaCount;
  const _DailyPlanCard({required this.hiraganaCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.vermillion.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'TODAY',
                  style: TextStyle(
                    color: AppColors.vermillion,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Learn 5 hiragana',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'DB ready · $hiraganaCount kana seeded',
            style: const TextStyle(color: AppColors.inkSoft, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          _ProgressBar(progress: 0.4),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(
          begin: 0.08,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        LayoutBuilder(
          builder: (_, c) => TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (_, v, __) => Container(
              height: 10,
              width: c.maxWidth * v,
              decoration: BoxDecoration(
                color: AppColors.vermillion,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SpringButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _SpringButton({required this.label, required this.color, required this.onTap});

  @override
  State<_SpringButton> createState() => _SpringButtonState();
}

class _SpringButtonState extends State<_SpringButton> {
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
        scale: _down ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

enum _Feedback {
  correct,
  wrong;

  String get id => '$name-${DateTime.now().microsecondsSinceEpoch}';
}

class _FeedbackOverlay extends StatefulWidget {
  final _Feedback kind;
  final VoidCallback onDone;
  const _FeedbackOverlay({super.key, required this.kind, required this.onDone});

  @override
  State<_FeedbackOverlay> createState() => _FeedbackOverlayState();
}

class _FeedbackOverlayState extends State<_FeedbackOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCorrect = widget.kind == _Feedback.correct;
    final color = isCorrect ? AppColors.success : AppColors.danger;

    return Stack(
      children: [
        FadeTransition(
          opacity: Tween(begin: 0.25, end: 0.0).animate(
            CurvedAnimation(parent: _c, curve: Curves.easeOut),
          ),
          child: Container(color: color),
        ),
        Center(
          child: ScaleTransition(
            scale: CurvedAnimation(parent: _c, curve: Curves.elasticOut),
            child: FadeTransition(
              opacity: Tween(begin: 1.0, end: 0.0).animate(
                CurvedAnimation(parent: _c, curve: const Interval(0.6, 1.0)),
              ),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(
                  isCorrect ? Icons.check_rounded : Icons.close_rounded,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
          ),
        ),
        if (isCorrect) _Confetti(controller: _c),
      ],
    );
  }
}

class _Confetti extends StatelessWidget {
  final AnimationController controller;
  const _Confetti({required this.controller});

  @override
  Widget build(BuildContext context) {
    final rnd = math.Random(7);
    final pieces = List.generate(20, (i) {
      final dx = rnd.nextDouble() * 2 - 1;
      final dy = -(rnd.nextDouble() * 0.8 + 0.4);
      final color = [
        AppColors.vermillion,
        AppColors.gold,
        AppColors.success,
      ][i % 3];
      return AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final t = controller.value;
          return Align(
            alignment: Alignment(dx * t * 1.4, dy * t + (t * t) * 1.6),
            child: Opacity(
              opacity: (1 - t).clamp(0, 1),
              child: Transform.rotate(
                angle: t * 6 * (i.isEven ? 1 : -1),
                child: Container(
                  width: 10,
                  height: 14,
                  color: color,
                ),
              ),
            ),
          );
        },
      );
    });
    return Stack(children: pieces);
  }
}
