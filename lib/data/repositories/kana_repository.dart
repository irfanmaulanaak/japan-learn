import '../database/database_helper.dart';
import '../models/kana.dart';

class KanaRepository {
  KanaRepository(this._db);
  final DatabaseHelper _db;

  Future<List<Kana>> all({String? type}) async {
    final db = await _db.database;
    final rows = await db.query(
      'kana',
      where: type != null ? 'type = ?' : null,
      whereArgs: type != null ? [type] : null,
      orderBy: 'row_group, order_index',
    );
    return rows.map(Kana.fromMap).toList();
  }

  Future<List<Kana>> byRow(String type, String rowGroup) async {
    final db = await _db.database;
    final rows = await db.query(
      'kana',
      where: 'type = ? AND row_group = ?',
      whereArgs: [type, rowGroup],
      orderBy: 'order_index',
    );
    return rows.map(Kana.fromMap).toList();
  }
}
