import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../theme/app_theme.dart';

class OnboardingChoice {
  final String label;
  final String detail;
  final bool enabled;
  const OnboardingChoice(this.label, this.detail, {this.enabled = true});
}

class OnboardingProgressHeader extends StatelessWidget {
  final int page;
  const OnboardingProgressHeader({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          page == 0 ? 'START' : 'STEP $page OF 3',
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            children: List.generate(3, (i) {
              final active = page > i;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 5,
                  margin: EdgeInsets.only(right: i == 2 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: active ? AppColors.accent : AppColors.hairline,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class OnboardingQuestionStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  const OnboardingQuestionStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            height: 1.1,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 15,
            height: 1.4,
            fontWeight: FontWeight.w600,
            color: AppColors.inkSoft,
          ),
        ),
        const SizedBox(height: 24),
        child,
      ],
    ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.03, end: 0);
  }
}

class OnboardingChoiceGroup extends StatelessWidget {
  final List<OnboardingChoice> choices;
  final String value;
  final ValueChanged<String> onChanged;
  const OnboardingChoiceGroup({
    super.key,
    required this.choices,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          choices
              .map(
                (choice) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ChoiceTile(
                    choice: choice,
                    selected: choice.label == value,
                    onTap: choice.enabled
                        ? () {
                            HapticFeedback.selectionClick();
                            onChanged(choice.label);
                          }
                        : null,
                  ),
                ),
              )
              .toList(),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  final OnboardingChoice choice;
  final bool selected;
  final VoidCallback? onTap;
  const _ChoiceTile({
    required this.choice,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Opacity(
      opacity: disabled ? 0.55 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
            decoration: BoxDecoration(
              color: selected ? AppColors.accentTint : AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color:
                      AppColors.ink.withValues(alpha: selected ? 0.02 : 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        choice.label,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        choice.detail,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (disabled)
                  const _SoonPill()
                else
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: selected ? AppColors.accent : AppColors.inkMuted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SoonPill extends StatelessWidget {
  const _SoonPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.hairline,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'SOON',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
          color: AppColors.inkMuted,
        ),
      ),
    );
  }
}

class OnboardingNumberStepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  const OnboardingNumberStepper({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Months',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ),
          _RoundIconButton(
            icon: Icons.remove_rounded,
            onTap: value <= min ? null : () => onChanged(value - 1),
          ),
          SizedBox(
            width: 54,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ),
          _RoundIconButton(
            icon: Icons.add_rounded,
            onTap: value >= max ? null : () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Material(
      color: enabled ? AppColors.accentTint : AppColors.hairline,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap:
            enabled
                ? () {
                  HapticFeedback.selectionClick();
                  onTap!();
                }
                : null,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            icon,
            size: 20,
            color: enabled ? AppColors.accentDark : AppColors.inkMuted,
          ),
        ),
      ),
    );
  }
}
