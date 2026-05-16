import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/database_helper.dart';
import 'models/kana.dart';
import 'models/user_goal.dart';
import 'repositories/kana_repository.dart';
import 'repositories/user_goal_repository.dart';

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

final kanaRepositoryProvider = Provider<KanaRepository>((ref) {
  return KanaRepository(ref.watch(databaseHelperProvider));
});

final userGoalRepositoryProvider = Provider<UserGoalRepository>((ref) {
  return UserGoalRepository(ref.watch(databaseHelperProvider));
});

final userGoalProvider = FutureProvider<UserGoal?>((ref) {
  return ref.watch(userGoalRepositoryProvider).current();
});

final hiraganaListProvider = FutureProvider<List<Kana>>((ref) {
  return ref.watch(kanaRepositoryProvider).all(type: Kana.typeHiragana);
});

final katakanaListProvider = FutureProvider<List<Kana>>((ref) {
  return ref.watch(kanaRepositoryProvider).all(type: Kana.typeKatakana);
});
