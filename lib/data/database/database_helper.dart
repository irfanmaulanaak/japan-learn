import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../seed/kana_seed.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'japan_learn.db';
  static const _dbVersion = 3;

  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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
    await _createUserGoalTable(db);
    await _createUserProgressTable(db);
    await _seedKana(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createUserGoalTable(db);
    }
    if (oldVersion < 3) {
      await _createUserProgressTable(db);
    }
  }

  Future<void> _createUserGoalTable(Database db) async {
    await db.execute('''
      CREATE TABLE user_goal (
        id INTEGER PRIMARY KEY,
        target_level TEXT NOT NULL,
        timeline_label TEXT NOT NULL,
        timeline_months INTEGER NOT NULL,
        starting_point TEXT NOT NULL,
        daily_kanji_goal INTEGER NOT NULL,
        daily_vocab_goal INTEGER NOT NULL,
        daily_review_minutes INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createUserProgressTable(Database db) async {
    await db.execute('''
      CREATE TABLE user_progress (
        id INTEGER PRIMARY KEY,
        xp INTEGER NOT NULL,
        streak_count INTEGER NOT NULL,
        modules_done INTEGER NOT NULL,
        modules_total INTEGER NOT NULL,
        day_number INTEGER NOT NULL,
        today_done INTEGER NOT NULL,
        review_due INTEGER NOT NULL,
        week_mask TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _seedKana(Database db) async {
    final batch = db.batch();
    for (final k in kanaSeedData) {
      batch.insert('kana', k.toMap());
    }
    await batch.commit(noResult: true);
  }
}
