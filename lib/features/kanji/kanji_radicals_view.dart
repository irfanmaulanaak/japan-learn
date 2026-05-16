import 'package:flutter/material.dart';

import '../../data/models/kanji.dart';
import '../../theme/app_theme.dart';

/// Groups kanji by primary radical for component-first browsing.
class KanjiRadicalsView extends StatefulWidget {
  final List<Kanji> kanji;
  const KanjiRadicalsView({super.key, required this.kanji});

  @override
  State<KanjiRadicalsView> createState() => _KanjiRadicalsViewState();
}

class _KanjiRadicalsViewState extends State<KanjiRadicalsView> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final byRadical = <String, List<Kanji>>{};
    for (final k in widget.kanji) {
      for (final r in k.radicalList) {
        byRadical.putIfAbsent(r, () => []).add(k);
      }
    }
    final radicals = byRadical.keys.toList()
      ..sort((a, b) => byRadical[b]!.length.compareTo(byRadical[a]!.length));
    final selected = _selected ?? radicals.first;
    final children = byRadical[selected] ?? const <Kanji>[];

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      children: [
        const Text(
          'RADICALS',
          style: TextStyle(
            color: AppColors.inkMuted,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: radicals
              .map(
                (r) => GestureDetector(
                  onTap: () => setState(() => _selected = r),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: r == selected
                          ? AppColors.accent
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.ink.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '$r  ${byRadical[r]!.length}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: r == selected ? Colors.white : AppColors.ink,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 22),
        Text(
          'Kanji containing $selected',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: children
              .map(
                (k) => Container(
                  width: 64,
                  height: 80,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.tintSage,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        k.character,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        k.meaning,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
