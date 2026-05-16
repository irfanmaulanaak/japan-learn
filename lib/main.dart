import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/providers.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'shell/app_shell.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: JapanLearnApp()));
}

class JapanLearnApp extends ConsumerWidget {
  const JapanLearnApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userGoal = ref.watch(userGoalProvider);

    return MaterialApp(
      title: 'Japan Learn',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: userGoal.when(
        data:
            (goal) =>
                goal == null ? const OnboardingScreen() : const AppShell(),
        loading: () => const _BootScreen(),
        error: (error, _) => _BootErrorScreen(error: error),
      ),
    );
  }
}

class _BootScreen extends StatelessWidget {
  const _BootScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
    );
  }
}

class _BootErrorScreen extends StatelessWidget {
  final Object error;
  const _BootErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'Could not load app data:\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
