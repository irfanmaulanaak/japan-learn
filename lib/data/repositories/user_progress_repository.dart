import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/user_progress.dart';

class UserProgressRepository {
  UserProgressRepository(this._db);
  final DatabaseHelper _db;

  Future<UserProgress> currentOrCreate() async {
    final db = await _db.database;
    final rows = await db.query('user_progress', orderBy: 'id ASC', limit: 1);
    if (rows.isNotEmpty) return UserProgress.fromMap(rows.first);

    final progress = UserProgress.initial(now: DateTime.now().toUtc());
    await save(progress);
    return progress;
  }

  Future<void> save(UserProgress progress) async {
    final db = await _db.database;
    await db.insert(
      'user_progress',
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
