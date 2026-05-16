import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../theme/app_theme.dart';
import '../kana/hiragana_screen.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hiraganaAsync = ref.watch(hiraganaListProvider);
    final hiraganaCount = hiraganaAsync.maybeWhen(data: (l) => l.length, orElse: () => 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            const _SectionLabel('Modules'),
            const SizedBox(height: 12),
            _ModuleRow(
              kanji: 'あ',
              tint: AppColors.accentTint,
              title: 'Hiragana',
              meta: '$hiraganaCount characters',
              status: _ModuleStatus.ready,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HiraganaScreen()),
              ),
            ),
            const _ModuleDivider(),
            const _ModuleRow(
              kanji: 'ア',
              tint: AppColors.tintSky,
              title: 'Katakana',
              meta: '46 characters',
              status: _ModuleStatus.locked,
            ),
            const _ModuleDivider(),
            const _ModuleRow(
              kanji: '漢',
              tint: AppColors.tintSage,
              title: 'Kanji',
              meta: 'by radical',
              status: _ModuleStatus.locked,
            ),
            const _ModuleDivider(),
            const _ModuleRow(
              kanji: '語',
              tint: AppColors.tintLavender,
              title: 'Vocabulary',
              meta: 'JLPT graded',
              status: _ModuleStatus.locked,
            ),
          ],
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

class _ModuleDivider extends StatelessWidget {
  const _ModuleDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppColors.hairline,
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}

enum _ModuleStatus { ready, inProgress, locked }

class _ModuleRow extends StatelessWidget {
  final String kanji;
  final Color tint;
  final String title;
  final String meta;
  final _ModuleStatus status;
  final VoidCallback? onTap;
  const _ModuleRow({
    required this.kanji,
    required this.tint,
    required this.title,
    required this.meta,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locked = status == _ModuleStatus.locked;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: locked
            ? null
            : () {
                HapticFeedback.lightImpact();
                onTap?.call();
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: locked ? AppColors.hairline : tint,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  kanji,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: locked ? AppColors.inkMuted : AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                        color: locked ? AppColors.inkMuted : AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meta,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.inkMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _ModuleStatusBadge(status: status),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 280.ms).slideY(begin: 0.03, end: 0, duration: 320.ms, curve: Curves.easeOutCubic);
  }
}

class _ModuleStatusBadge extends StatelessWidget {
  final _ModuleStatus status;
  const _ModuleStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case _ModuleStatus.locked:
        return const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.inkMuted);
      case _ModuleStatus.ready:
        return const Icon(Icons.arrow_forward_rounded, size: 20, color: AppColors.ink);
      case _ModuleStatus.inProgress:
        return Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
        );
    }
  }
}
