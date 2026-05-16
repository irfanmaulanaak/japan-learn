import 'package:flutter/material.dart';

void main() {
  runApp(const JapanLearnApp());
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
        fontFamily: 'NotoSansJP',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Japan Learn'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Welcome to Japan Learn!'),
      ),
    );
  }
}
