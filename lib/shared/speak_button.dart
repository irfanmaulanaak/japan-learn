import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import '../theme/app_theme.dart';

/// Tappable speaker icon that reads [text] aloud in Japanese via TTS.
/// Self-contained: pulls the TTS service from Riverpod so plain widgets can
/// drop it in without threading `ref` through.
class SpeakButton extends ConsumerWidget {
  final String text;
  final double size;
  final Color? color;
  final Color? background;
  const SpeakButton({
    super.key,
    required this.text,
    this.size = 22,
    this.color,
    this.background,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: background ?? AppColors.accentTint,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          HapticFeedback.selectionClick();
          ref.read(ttsServiceProvider).speak(text);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            Icons.volume_up_rounded,
            size: size,
            color: color ?? AppColors.accentDark,
          ),
        ),
      ),
    );
  }
}
