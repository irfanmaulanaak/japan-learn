import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../shared/speak_button.dart';
import '../../theme/app_theme.dart';

/// Shadowing practice. Plays the line via on-device TTS so learners have
/// native audio to mimic, then self-rate their attempt. Record + playback
/// compare remains a follow-up plug-in point.
class ShadowingScreen extends ConsumerStatefulWidget {
  const ShadowingScreen({super.key});

  @override
  ConsumerState<ShadowingScreen> createState() => _ShadowingScreenState();
}

class _ShadowingScreenState extends ConsumerState<ShadowingScreen> {
  static const _lines = [
    _ShadowLine('おはようございます。', 'Good morning.'),
    _ShadowLine('ありがとうございます。', 'Thank you very much.'),
    _ShadowLine('お名前は何ですか。', 'What is your name?'),
    _ShadowLine('もう一度お願いします。', 'One more time, please.'),
    _ShadowLine('日本語が少しわかります。', 'I understand a little Japanese.'),
    _ShadowLine('駅はどこですか。', 'Where is the station?'),
    _ShadowLine('これはいくらですか。', 'How much is this?'),
  ];

  int _index = 0;
  bool _revealed = false;
  bool _saving = false;

  void _reveal() {
    HapticFeedback.lightImpact();
    setState(() => _revealed = true);
  }

  Future<void> _rate(int self) async {
    if (_saving) return;
    setState(() => _saving = true);
    HapticFeedback.lightImpact();
    final xp = self == 2 ? 6 : (self == 1 ? 3 : 1);
    await ref.read(lessonRecorderProvider).recordReview(xpEarned: xp);
    ref.invalidate(userProgressProvider);
    ref.invalidate(earnedBadgesProvider);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _revealed = false;
      _index = (_index + 1) % _lines.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final line = _lines[_index];
    return Scaffold(
      appBar: AppBar(title: const Text('Shadowing')),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LINE ${_index + 1} / ${_lines.length}',
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line.ja,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        height: 1.3,
                      ),
                    ),
                    if (_revealed) ...[
                      const SizedBox(height: 12),
                      Text(
                        line.en,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.inkSoft,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SpeakButton(text: line.ja, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Tap to listen, then say it out loud. Match the rhythm '
                      'and repeat several times.',
                      style: TextStyle(
                        color: AppColors.inkSoft,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (!_revealed)
                FilledButton(
                  onPressed: _reveal,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Show translation',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: _RateBtn(
                        label: 'Rough',
                        color: AppColors.hairline,
                        textColor: AppColors.ink,
                        onTap: _saving ? null : () => _rate(0),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _RateBtn(
                        label: 'OK',
                        color: AppColors.accentTint,
                        textColor: AppColors.accentDark,
                        onTap: _saving ? null : () => _rate(1),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _RateBtn(
                        label: 'Smooth',
                        color: AppColors.accent,
                        textColor: Colors.white,
                        onTap: _saving ? null : () => _rate(2),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShadowLine {
  final String ja;
  final String en;
  const _ShadowLine(this.ja, this.en);
}

class _RateBtn extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback? onTap;
  const _RateBtn({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        disabledBackgroundColor: AppColors.hairline,
        disabledForegroundColor: AppColors.inkMuted,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
      ),
    );
  }
}
