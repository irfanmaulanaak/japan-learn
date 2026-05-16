import 'package:flutter/material.dart';

import '../../shared/placeholder_screen.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Dictionary',
      emoji: '辞',
      subtitle: 'Offline JP↔EN search lives here.',
    );
  }
}
