import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../seed/kana_seed.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'japan_learn.db';
  static const _dbVersion = 1;

  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE kana (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        character TEXT NOT NULL,
        romaji TEXT NOT NULL,
        type TEXT NOT NULL,
        row_group TEXT NOT NULL,
        order_index INTEGER NOT NULL
      )
    ''');
    await _seedKana(db);
  }

  Future<void> _seedKana(Database db) async {
    final batch = db.batch();
    for (final k in kanaSeedData) {
      batch.insert('kana', k.toMap());
    }
    await batch.commit(noResult: true);
  }
}
