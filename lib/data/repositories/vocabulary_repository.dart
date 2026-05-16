import '../database/database_helper.dart';
import '../models/vocabulary.dart';

class VocabularyRepository {
  VocabularyRepository(this._db);
  final DatabaseHelper _db;

  Future<List<Vocabulary>> all() async {
    final db = await _db.database;
    final rows = await db.query('vocabulary', orderBy: 'level, id');
    return rows.map(Vocabulary.fromMap).toList();
  }

  Future<List<Vocabulary>> byLevel(String level) async {
    final db = await _db.database;
    final rows = await db.query(
      'vocabulary',
      where: 'level = ?',
      whereArgs: [level],
      orderBy: 'id',
    );
    return rows.map(Vocabulary.fromMap).toList();
  }

  Future<List<Vocabulary>> search(String query) async {
    if (query.trim().isEmpty) return [];
    final db = await _db.database;
    final like = '%${query.trim()}%';
    final rows = await db.query(
      'vocabulary',
      where: 'word LIKE ? OR reading LIKE ? OR meaning LIKE ?',
      whereArgs: [like, like, like],
      orderBy: 'level, id',
      limit: 60,
    );
    return rows.map(Vocabulary.fromMap).toList();
  }

  Future<Vocabulary?> byId(int id) async {
    final db = await _db.database;
    final rows = await db.query(
      'vocabulary',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Vocabulary.fromMap(rows.first);
  }
}
