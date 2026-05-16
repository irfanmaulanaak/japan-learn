import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/user_goal.dart';

class UserGoalRepository {
  UserGoalRepository(this._db);
  final DatabaseHelper _db;

  Future<UserGoal?> current() async {
    final db = await _db.database;
    final rows = await db.query('user_goal', orderBy: 'id ASC', limit: 1);
    if (rows.isEmpty) return null;
    return UserGoal.fromMap(rows.first);
  }

  Future<void> save(UserGoal goal) async {
    final db = await _db.database;
    await db.insert(
      'user_goal',
      goal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
