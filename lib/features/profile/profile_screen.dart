import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/badge.dart';
import '../../data/models/user_progress.dart';
import '../../data/providers.dart';
import '../../theme/app_theme.dart';
import '../anki/anki_import_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(userProgressProvider);
    final badgesAsync = ref.watch(earnedBadgesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('You')),
      body: progressAsync.when(
        data:
            (progress) => badgesAsync.when(
              data:
                  (earned) => ListView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                    children: [
                      _LevelCard(xp: progress.xp, level: progress.level),
                      const SizedBox(height: 28),
                      _Row(
                        label: 'Streak',
                        value: '${progress.streakCount} days',
                      ),
                      _Row(
                        label: 'Streak freezes',
                        value:
                            '${progress.freezeTokens} / ${UserProgress.maxFreezeTokens}',
                      ),
                      _Row(label: 'XP', value: '${progress.xp}'),
                      _Row(
                        label: 'Day in plan',
                        value: '${progress.dayNumber}',
                      ),
                      _Row(
                        label: 'Modules done',
                        value:
                            '${progress.modulesDone}/${progress.modulesTotal}',
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'A streak freeze auto-covers one missed day. Earn one for '
                        'every 5-day streak (max 2).',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.inkMuted,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const _SectionLabel('Badges'),
                      const SizedBox(height: 12),
                      _BadgeGrid(earned: earned),
                      const SizedBox(height: 28),
                      const _SectionLabel('Tools'),
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.upload_file_rounded,
                          color: AppColors.ink,
                        ),
                        title: const Text(
                          'Import Anki deck',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        subtitle: const Text(
                          'Bring .apkg cards into your SRS.',
                          style: TextStyle(
                            color: AppColors.inkMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AnkiImportScreen(),
                              ),
                            ),
                      ),
                    ],
                  ),
              loading: () => const _Loading(),
              error: (e, _) => _Err(error: e),
            ),
        loading: () => const _Loading(),
        error: (e, _) => _Err(error: e),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();
  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator(color: AppColors.accent));
}

class _Err extends StatelessWidget {
  final Object error;
  const _Err({required this.error});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text('$error', style: const TextStyle(color: AppColors.danger)),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int xp;
  final int level;
  const _LevelCard({required this.xp, required this.level});

  @override
  Widget build(BuildContext context) {
    final xpInLevel = xp % 100;
    final progress = xpInLevel / 100;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LEVEL',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$level',
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Stack(
              children: [
                Container(
                  height: 8,
                  color: Colors.white.withValues(alpha: 0.25),
                ),
                LayoutBuilder(
                  builder:
                      (_, c) => TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutCubic,
                        builder:
                            (_, v, _) => Container(
                              height: 8,
                              width: c.maxWidth * v,
                              color: Colors.white,
                            ),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$xpInLevel / 100 XP to level ${level + 1}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.inkSoft,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: AppColors.inkMuted,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  final Set<String> earned;
  const _BadgeGrid({required this.earned});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          BadgeCatalog.items
              .map(
                (b) => SizedBox(
                  width: (MediaQuery.of(context).size.width - 60) / 2,
                  child: _BadgeTile(badge: b, earned: earned.contains(b.code)),
                ),
              )
              .toList(),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final BadgeDef badge;
  final bool earned;
  const _BadgeTile({required this.badge, required this.earned});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: earned ? AppColors.accentTint : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            earned
                ? Icons.workspace_premium_rounded
                : Icons.lock_outline_rounded,
            color: earned ? AppColors.accentDark : AppColors.inkMuted,
            size: 22,
          ),
          const SizedBox(height: 6),
          Text(
            badge.title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: earned ? AppColors.ink : AppColors.inkSoft,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            badge.detail,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.inkMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
