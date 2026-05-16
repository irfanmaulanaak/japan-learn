import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models/card_progress.dart';
import '../../theme/app_theme.dart';
import 'deck_card.dart';

class DeckBrowseView extends StatelessWidget {
  final List<DeckCard> cards;
  final Map<int, CardProgress> progress;
  final void Function(DeckCard card) onTap;
  const DeckBrowseView({
    super.key,
    required this.cards,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      itemCount: cards.length,
      separatorBuilder: (_, _) => Container(
        height: 1,
        color: AppColors.hairline,
      ),
      itemBuilder: (context, index) {
        final card = cards[index];
        final state = progress[card.id];
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onTap(card),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: Text(
                    card.front,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (card.subtitle != null)
                        Text(
                          card.subtitle!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.inkSoft,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      const SizedBox(height: 2),
                      Text(
                        card.back,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(state: state, now: now),
              ],
            ),
          ),
        ).animate(delay: (index * 6).ms).fadeIn(duration: 220.ms);
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final CardProgress? state;
  final DateTime now;
  const _StatusBadge({required this.state, required this.now});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    final s = state?.state;
    if (s == null || s.isNew) {
      label = 'NEW';
      color = AppColors.inkMuted;
    } else if (s.isDue(now)) {
      label = 'DUE';
      color = AppColors.accent;
    } else if (s.isMastered) {
      label = 'OK';
      color = AppColors.success;
    } else {
      label = 'LEARN';
      color = AppColors.inkSoft;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
