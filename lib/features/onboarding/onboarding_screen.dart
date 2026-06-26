import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_goal.dart';
import '../../data/providers.dart';
import 'onboarding_choice_widgets.dart';
import 'onboarding_summary_widgets.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _targetLevels = [
    OnboardingChoice('N5', 'First JLPT goal'),
    OnboardingChoice('N4', 'Upper beginner', enabled: false),
    OnboardingChoice('N3', 'Lower intermediate', enabled: false),
    OnboardingChoice('N2', 'Advanced workhorse', enabled: false),
    OnboardingChoice('N1', 'Full fluency track', enabled: false),
  ];

  static const _timelines = [
    OnboardingChoice('3 months', 'Fast daily pace'),
    OnboardingChoice('6 months', 'Steady pace'),
    OnboardingChoice('1 year', 'Long runway'),
    OnboardingChoice('Custom', 'Pick your months'),
  ];

  static const _startingPoints = [
    OnboardingChoice('Absolute beginner', 'Start with kana'),
    OnboardingChoice('Know hiragana', 'Skip the first basics'),
    OnboardingChoice('Some kanji', 'Build from your base'),
    OnboardingChoice('Returning learner', 'Refresh and advance'),
  ];

  int _page = 0;
  String _targetLevel = 'N5';
  String _timeline = '3 months';
  int _customMonths = 9;
  String _startingPoint = 'Absolute beginner';
  bool _saving = false;

  int get _timelineMonths {
    switch (_timeline) {
      case '3 months':
        return 3;
      case '6 months':
        return 6;
      case '1 year':
        return 12;
      case 'Custom':
        return _customMonths;
    }
    return 3;
  }

  String get _timelineLabel {
    if (_timeline == 'Custom') return '$_customMonths months';
    return _timeline;
  }

  void _next() {
    HapticFeedback.selectionClick();
    if (_page < 3) {
      setState(() => _page += 1);
      return;
    }
    _finish();
  }

  void _back() {
    if (_page == 0 || _saving) return;
    HapticFeedback.selectionClick();
    setState(() => _page -= 1);
  }

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);
    HapticFeedback.mediumImpact();

    final goal = UserGoal.fromAnswers(
      targetLevel: _targetLevel,
      timelineLabel: _timelineLabel,
      timelineMonths: _timelineMonths,
      startingPoint: _startingPoint,
      createdAt: DateTime.now().toUtc(),
    );

    try {
      await ref.read(userGoalRepositoryProvider).save(goal);
      if (!mounted) return;
      ref.invalidate(userGoalProvider);
    } catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'onboarding',
          context: ErrorDescription('saving user goal'),
        ),
      );
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save goal: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              OnboardingProgressHeader(page: _page),
              const SizedBox(height: 24),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder:
                      (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.03, 0),
                            end: Offset.zero,
                          ).animate(anim),
                          child: child,
                        ),
                      ),
                  child: SingleChildScrollView(
                    key: ValueKey(_page),
                    child: _pageContent(),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              OnboardingFooter(
                page: _page,
                saving: _saving,
                onBack: _back,
                onNext: _next,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pageContent() {
    switch (_page) {
      case 0:
        return const OnboardingWelcomeStep();
      case 1:
        return OnboardingQuestionStep(
          title: 'Target JLPT level',
          subtitle: 'N5 is ready now. Higher levels are coming soon.',
          child: OnboardingChoiceGroup(
            choices: _targetLevels,
            value: _targetLevel,
            onChanged: (value) => setState(() => _targetLevel = value),
          ),
        );
      case 2:
        return OnboardingQuestionStep(
          title: 'Timeline',
          subtitle: 'Pick the target pace for your daily plan.',
          child: Column(
            children: [
              OnboardingChoiceGroup(
                choices: _timelines,
                value: _timeline,
                onChanged: (value) => setState(() => _timeline = value),
              ),
              if (_timeline == 'Custom') ...[
                const SizedBox(height: 14),
                OnboardingNumberStepper(
                  value: _customMonths,
                  min: 2,
                  max: 24,
                  onChanged: (value) => setState(() => _customMonths = value),
                ),
              ],
            ],
          ),
        );
      case 3:
        final goal = UserGoal.fromAnswers(
          targetLevel: _targetLevel,
          timelineLabel: _timelineLabel,
          timelineMonths: _timelineMonths,
          startingPoint: _startingPoint,
          createdAt: DateTime.now().toUtc(),
        );
        return OnboardingQuestionStep(
          title: 'Starting point',
          subtitle: 'Set the first lessons to match what you know.',
          child: Column(
            children: [
              OnboardingChoiceGroup(
                choices: _startingPoints,
                value: _startingPoint,
                onChanged: (value) => setState(() => _startingPoint = value),
              ),
              const SizedBox(height: 18),
              OnboardingPlanPreview(goal: goal),
            ],
          ),
        );
    }
    return const SizedBox.shrink();
  }
}
