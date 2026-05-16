import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/database_helper.dart';
import 'models/kana.dart';
import 'repositories/kana_repository.dart';

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

final kanaRepositoryProvider = Provider<KanaRepository>((ref) {
  return KanaRepository(ref.watch(databaseHelperProvider));
});

final hiraganaListProvider = FutureProvider<List<Kana>>((ref) {
  return ref.watch(kanaRepositoryProvider).all(type: Kana.typeHiragana);
});

final katakanaListProvider = FutureProvider<List<Kana>>((ref) {
  return ref.watch(kanaRepositoryProvider).all(type: Kana.typeKatakana);
});
