import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../data/seed/reading_seed.dart';
import '../../theme/app_theme.dart';

class ReadingScreen extends ConsumerWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reading')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            const Text(
              'GRADED PASSAGES',
              style: TextStyle(
                color: AppColors.inkMuted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            ...readingPassages.map(
              (p) => _PassageRow(
                passage: p,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ReadingDetailScreen(passage: p),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PassageRow extends StatelessWidget {
  final ReadingPassage passage;
  final VoidCallback onTap;
  const _PassageRow({required this.passage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.fromLTRB(16, 6, 12, 6),
        title: Text(
          passage.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
            letterSpacing: -0.2,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            '${passage.level} · +${passage.xpReward} XP',
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_rounded, color: AppColors.ink),
      ),
    ).animate().fadeIn(duration: 220.ms);
  }
}

class ReadingDetailScreen extends ConsumerStatefulWidget {
  final ReadingPassage passage;
  const ReadingDetailScreen({super.key, required this.passage});

  @override
  ConsumerState<ReadingDetailScreen> createState() =>
      _ReadingDetailScreenState();
}

class _ReadingDetailScreenState extends ConsumerState<ReadingDetailScreen> {
  bool _showTranslation = false;
  bool _awarded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.passage;
    return Scaffold(
      appBar: AppBar(title: Text(p.level)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            Text(
              p.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                p.body,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.7,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () =>
                  setState(() => _showTranslation = !_showTranslation),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.ink,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _showTranslation ? 'Hide translation' : 'Show translation',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            if (_showTranslation) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  p.translation,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.inkSoft,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 22),
            FilledButton(
              onPressed: _awarded ? null : _finish,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.hairline,
                disabledForegroundColor: AppColors.inkMuted,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _awarded ? 'Completed' : 'Mark as read (+${p.xpReward} XP)',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _finish() async {
    await ref
        .read(lessonRecorderProvider)
        .recordReview(xpEarned: widget.passage.xpReward);
    ref.invalidate(userProgressProvider);
    ref.invalidate(earnedBadgesProvider);
    if (!mounted) return;
    setState(() => _awarded = true);
  }
}
