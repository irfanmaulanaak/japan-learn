import 'package:flutter/material.dart';

import '../../shared/placeholder_screen.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Learn',
      emoji: '学',
      subtitle: 'Hiragana, katakana, kanji & vocab modules land here.',
    );
  }
}
