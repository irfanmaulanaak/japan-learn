import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/database_helper.dart';
import 'models/kana.dart';
import 'models/kana_progress.dart';
import 'models/user_goal.dart';
import 'models/user_progress.dart';
import 'repositories/kana_progress_repository.dart';
import 'repositories/kana_repository.dart';
import 'repositories/user_goal_repository.dart';
import 'repositories/user_progress_repository.dart';

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

final kanaRepositoryProvider = Provider<KanaRepository>((ref) {
  return KanaRepository(ref.watch(databaseHelperProvider));
});

final kanaProgressRepositoryProvider = Provider<KanaProgressRepository>((ref) {
  return KanaProgressRepository(ref.watch(databaseHelperProvider));
});

final userGoalRepositoryProvider = Provider<UserGoalRepository>((ref) {
  return UserGoalRepository(ref.watch(databaseHelperProvider));
});

final userProgressRepositoryProvider = Provider<UserProgressRepository>((ref) {
  return UserProgressRepository(ref.watch(databaseHelperProvider));
});

final userGoalProvider = FutureProvider<UserGoal?>((ref) {
  return ref.watch(userGoalRepositoryProvider).current();
});

final userProgressProvider = FutureProvider<UserProgress>((ref) {
  return ref.watch(userProgressRepositoryProvider).currentOrCreate();
});

final hiraganaListProvider = FutureProvider<List<Kana>>((ref) {
  return ref.watch(kanaRepositoryProvider).all(type: Kana.typeHiragana);
});

final hiraganaProgressProvider = FutureProvider<Map<int, KanaProgress>>((
  ref,
) async {
  final kana = await ref.watch(hiraganaListProvider.future);
  final ids = kana.map((k) => k.id).nonNulls.toList();
  return ref.watch(kanaProgressRepositoryProvider).byKanaIds(ids);
});

final katakanaListProvider = FutureProvider<List<Kana>>((ref) {
  return ref.watch(kanaRepositoryProvider).all(type: Kana.typeKatakana);
});
