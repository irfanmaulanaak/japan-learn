import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models/user_goal.dart';
import '../../theme/app_theme.dart';

class OnboardingWelcomeStep extends StatelessWidget {
  const OnboardingWelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 86,
          height: 86,
          decoration: BoxDecoration(
            color: AppColors.accentTint,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: const Text(
            '日',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: AppColors.accentDark,
            ),
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'Build your daily path',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
            height: 1.06,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Three answers set your JLPT goal, timeline, and first lessons.',
          style: TextStyle(
            fontSize: 16,
            height: 1.45,
            fontWeight: FontWeight.w600,
            color: AppColors.inkSoft,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 320.ms).slideY(begin: 0.04, end: 0);
  }
}

class OnboardingPlanPreview extends StatelessWidget {
  final UserGoal goal;
  const OnboardingPlanPreview({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${goal.targetLevel} · ${goal.timelineLabel}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Daily plan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PlanStat(
                  value: '${goal.dailyKanjiGoal}',
                  label: 'kanji',
                ),
              ),
              Expanded(
                child: _PlanStat(
                  value: '${goal.dailyVocabGoal}',
                  label: 'vocab',
                ),
              ),
              Expanded(
                child: _PlanStat(
                  value: '${goal.dailyReviewMinutes}',
                  label: 'min review',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanStat extends StatelessWidget {
  final String value;
  final String label;
  const _PlanStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.78),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class OnboardingFooter extends StatelessWidget {
  final int page;
  final bool saving;
  final VoidCallback onBack;
  final VoidCallback onNext;
  const OnboardingFooter({
    super.key,
    required this.page,
    required this.saving,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final label =
        page == 0 ? 'Start setup' : (page == 3 ? 'Finish' : 'Continue');
    return Row(
      children: [
        if (page > 0) ...[
          _BackButton(onTap: onBack),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: FilledButton(
            onPressed: saving ? null : onNext,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.hairline,
              disabledForegroundColor: AppColors.inkMuted,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child:
                saving
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
          ),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: const SizedBox(
          width: 54,
          height: 54,
          child: Icon(Icons.arrow_back_rounded, color: AppColors.ink),
        ),
      ),
    );
  }
}
