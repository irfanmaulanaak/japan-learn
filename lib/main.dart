import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/providers.dart';

void main() {
  runApp(const ProviderScope(child: JapanLearnApp()));
}

class JapanLearnApp extends StatelessWidget {
  const JapanLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Japan Learn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFD32F2F),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hiragana = ref.watch(hiraganaListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Japan Learn'),
        centerTitle: true,
      ),
      body: hiragana.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) => Center(
          child: Text(
            'DB OK — loaded ${list.length} hiragana',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
