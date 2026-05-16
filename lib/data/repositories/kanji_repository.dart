import '../database/database_helper.dart';
import '../models/kanji.dart';

class KanjiRepository {
  KanjiRepository(this._db);
  final DatabaseHelper _db;

  Future<List<Kanji>> all() async {
    final db = await _db.database;
    final rows = await db.query('kanji', orderBy: 'level, id');
    return rows.map(Kanji.fromMap).toList();
  }

  Future<List<Kanji>> byLevel(String level) async {
    final db = await _db.database;
    final rows = await db.query(
      'kanji',
      where: 'level = ?',
      whereArgs: [level],
      orderBy: 'id',
    );
    return rows.map(Kanji.fromMap).toList();
  }

  Future<List<Kanji>> search(String query) async {
    if (query.trim().isEmpty) return [];
    final db = await _db.database;
    final like = '%${query.trim()}%';
    final rows = await db.query(
      'kanji',
      where:
          'character LIKE ? OR meaning LIKE ? OR onyomi LIKE ? OR kunyomi LIKE ?',
      whereArgs: [like, like, like, like],
      orderBy: 'level, id',
      limit: 60,
    );
    return rows.map(Kanji.fromMap).toList();
  }

  Future<List<Kanji>> byRadical(String radical) async {
    final db = await _db.database;
    final rows = await db.query(
      'kanji',
      where: 'radicals LIKE ?',
      whereArgs: ['%$radical%'],
      orderBy: 'strokes, id',
    );
    return rows.map(Kanji.fromMap).toList();
  }

  Future<Kanji?> byId(int id) async {
    final db = await _db.database;
    final rows = await db.query(
      'kanji',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Kanji.fromMap(rows.first);
  }
}
