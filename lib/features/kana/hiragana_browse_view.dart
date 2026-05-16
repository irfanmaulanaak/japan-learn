import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models/kana.dart';
import '../../data/models/kana_progress.dart';
import '../../theme/app_theme.dart';

class HiraganaBrowseView extends StatelessWidget {
  final List<Kana> kana;
  final Map<int, KanaProgress> progress;
  const HiraganaBrowseView({
    super.key,
    required this.kana,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemCount: kana.length,
      itemBuilder: (context, index) {
        final item = kana[index];
        final state = item.id == null ? null : progress[item.id!];
        return _KanaTile(item: item, progress: state, now: now)
            .animate(delay: (index * 8).ms)
            .fadeIn(duration: 220.ms)
            .scale(begin: const Offset(0.98, 0.98));
      },
    );
  }
}

class _KanaTile extends StatelessWidget {
  final Kana item;
  final KanaProgress? progress;
  final DateTime now;
  const _KanaTile({
    required this.item,
    required this.progress,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final label = _statusLabel();
    final tint = _statusTint();

    return Container(
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.character,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.romaji,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.inkSoft,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel() {
    final p = progress;
    if (p == null || p.isNew) return 'NEW';
    if (p.isDue(now)) return 'DUE';
    if (p.isMastered) return 'OK';
    return 'LEARN';
  }

  Color _statusTint() {
    final p = progress;
    if (p == null || p.isNew) return AppColors.surface;
    if (p.isDue(now)) return AppColors.accentTint;
    if (p.isMastered) return AppColors.tintSage;
    return AppColors.tintSky;
  }
}
