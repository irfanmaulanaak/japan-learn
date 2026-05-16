import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shell/app_shell.dart';
import 'theme/app_theme.dart';

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
      theme: buildAppTheme(),
      home: const AppShell(),
    );
  }
}
