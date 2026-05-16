import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/card_progress.dart';

class CardProgressRepository {
  CardProgressRepository(this._db);
  final DatabaseHelper _db;

  Future<Map<int, CardProgress>> byDeckIds({
    required String deck,
    required List<int> itemIds,
  }) async {
    if (itemIds.isEmpty) return {};
    final db = await _db.database;
    final marks = List.filled(itemIds.length, '?').join(',');
    final rows = await db.query(
      'card_progress',
      where: 'deck = ? AND item_id IN ($marks)',
      whereArgs: [deck, ...itemIds],
    );
    return {
      for (final row in rows)
        (row['item_id'] as int): CardProgress.fromMap(row),
    };
  }

  Future<void> save(CardProgress progress) async {
    final db = await _db.database;
    await db.insert(
      'card_progress',
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> dueCount({required String deck, required DateTime now}) async {
    final db = await _db.database;
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM card_progress WHERE deck = ? '
      'AND repetition_count > 0 AND due_at <= ?',
      [deck, now.toIso8601String()],
    );
    return (rows.first['c'] as int?) ?? 0;
  }

  /// Count rows considered "mastered" by SM-2 heuristic
  /// (repetition_count >= 4 AND interval_days >= 14).
  Future<int> masteredCount(String deck) async {
    final db = await _db.database;
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM card_progress '
      'WHERE deck = ? AND repetition_count >= 4 AND interval_days >= 14',
      [deck],
    );
    return (rows.first['c'] as int?) ?? 0;
  }
}
