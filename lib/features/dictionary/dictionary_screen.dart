import 'package:flutter/material.dart';

import '../../shared/placeholder_screen.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Dictionary',
      subtitle: 'Offline Japanese ↔ English search.',
    );
  }
}
