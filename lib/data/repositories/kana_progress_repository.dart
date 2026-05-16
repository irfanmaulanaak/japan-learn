import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/kana_progress.dart';

class KanaProgressRepository {
  KanaProgressRepository(this._db);
  final DatabaseHelper _db;

  Future<Map<int, KanaProgress>> byKanaIds(List<int> kanaIds) async {
    if (kanaIds.isEmpty) return {};

    final db = await _db.database;
    final marks = List.filled(kanaIds.length, '?').join(',');
    final rows = await db.query(
      'kana_progress',
      where: 'kana_id IN ($marks)',
      whereArgs: kanaIds,
    );
    return {
      for (final row in rows)
        (row['kana_id'] as int): KanaProgress.fromMap(row),
    };
  }

  Future<void> save(KanaProgress progress) async {
    final db = await _db.database;
    await db.insert(
      'kana_progress',
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
