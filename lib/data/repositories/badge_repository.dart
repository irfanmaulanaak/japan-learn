import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/badge.dart';

class BadgeRepository {
  BadgeRepository(this._db);
  final DatabaseHelper _db;

  Future<Set<String>> earnedCodes() async {
    final db = await _db.database;
    final rows = await db.query('badge', columns: ['code']);
    return rows.map((r) => r['code'] as String).toSet();
  }

  Future<List<EarnedBadge>> earned() async {
    final db = await _db.database;
    final rows = await db.query('badge', orderBy: 'earned_at DESC');
    return rows.map(EarnedBadge.fromMap).toList();
  }

  Future<bool> grant(String code) async {
    final db = await _db.database;
    final existing = await db.query(
      'badge',
      where: 'code = ?',
      whereArgs: [code],
      limit: 1,
    );
    if (existing.isNotEmpty) return false;
    await db.insert(
      'badge',
      EarnedBadge(code: code, earnedAt: DateTime.now()).toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return true;
  }
}
