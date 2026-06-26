import 'package:flutter_tts/flutter_tts.dart';

/// Thin wrapper over flutter_tts pinned to Japanese. Speaks kana / vocab /
/// sentences out loud so beginners hear native pronunciation. Speech rate is
/// slowed down a touch since the audience is learners, not native readers.
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _ready = false;

  Future<void> _ensureReady() async {
    if (_ready) return;
    await _tts.setLanguage('ja-JP');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    _ready = true;
  }

  /// Speaks [text] in Japanese. Interrupts anything already playing so rapid
  /// taps don't queue up. No-op for empty text.
  Future<void> speak(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    await _ensureReady();
    await _tts.stop();
    await _tts.speak(trimmed);
  }

  Future<void> stop() => _tts.stop();
}
