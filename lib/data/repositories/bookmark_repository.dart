import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/bookmark.dart';

class BookmarkRepository {
  BookmarkRepository(this._db);
  final DatabaseHelper _db;

  Future<List<Bookmark>> all() async {
    final db = await _db.database;
    final rows = await db.query('bookmark', orderBy: 'created_at DESC');
    return rows.map(Bookmark.fromMap).toList();
  }

  Future<bool> exists({required String kind, required int itemId}) async {
    final db = await _db.database;
    final rows = await db.query(
      'bookmark',
      where: 'kind = ? AND item_id = ?',
      whereArgs: [kind, itemId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  Future<void> toggle({required String kind, required int itemId}) async {
    final db = await _db.database;
    final existing = await db.query(
      'bookmark',
      where: 'kind = ? AND item_id = ?',
      whereArgs: [kind, itemId],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      await db.delete(
        'bookmark',
        where: 'kind = ? AND item_id = ?',
        whereArgs: [kind, itemId],
      );
      return;
    }
    await db.insert(
      'bookmark',
      Bookmark(
        kind: kind,
        itemId: itemId,
        createdAt: DateTime.now(),
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
