import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../seed/kana_seed.dart';
import '../seed/kanji_seed.dart';
import '../seed/kanji_seed_extra.dart';
import '../seed/vocabulary_seed.dart';
import '../seed/vocabulary_seed_extra.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'japan_learn.db';
  static const _dbVersion = 7;

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
    await _createKanaProgressTable(db);
    await _createVocabularyTable(db);
    await _createKanjiTable(db);
    await _createCardProgressTable(db);
    await _createBookmarkTable(db);
    await _createBadgeTable(db);
    await _seedKana(db);
    await _seedVocabulary(db);
    await _seedKanji(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) await _createUserGoalTable(db);
    if (oldVersion < 3) await _createUserProgressTable(db);
    if (oldVersion < 4) await _createKanaProgressTable(db);
    if (oldVersion < 5) {
      await _createVocabularyTable(db);
      await _createKanjiTable(db);
      await _createCardProgressTable(db);
      await _seedVocabulary(db);
      await _seedKanji(db);
    }
    if (oldVersion < 6) {
      await _createBookmarkTable(db);
      await _createBadgeTable(db);
    }
    if (oldVersion < 7) {
      // Append extended kana (dakuten/handakuten/yoon) + extra N5 vocab/kanji.
      // Inserts only the new rows so existing ids and SRS progress survive.
      await _seedRows(db, 'kana', kanaExtendedSeedData.map((k) => k.toMap()));
      await _seedRows(
        db,
        'vocabulary',
        vocabularyExtraSeedData.map((v) => v.toMap()),
      );
      await _seedRows(db, 'kanji', kanjiExtraSeedData.map((k) => k.toMap()));
    }
  }

  Future<void> _seedRows(
    Database db,
    String table,
    Iterable<Map<String, Object?>> rows,
  ) async {
    final batch = db.batch();
    for (final row in rows) {
      batch.insert(table, row);
    }
    await batch.commit(noResult: true);
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

  Future<void> _createKanaProgressTable(Database db) async {
    await db.execute('''
      CREATE TABLE kana_progress (
        kana_id INTEGER PRIMARY KEY,
        easiness REAL NOT NULL,
        interval_days INTEGER NOT NULL,
        repetition_count INTEGER NOT NULL,
        lapse_count INTEGER NOT NULL,
        due_at TEXT NOT NULL,
        last_reviewed_at TEXT,
        FOREIGN KEY (kana_id) REFERENCES kana (id)
      )
    ''');
  }

  Future<void> _createVocabularyTable(Database db) async {
    await db.execute('''
      CREATE TABLE vocabulary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        reading TEXT NOT NULL,
        meaning TEXT NOT NULL,
        part_of_speech TEXT NOT NULL,
        level TEXT NOT NULL,
        example_ja TEXT,
        example_en TEXT
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_vocabulary_level ON vocabulary(level)',
    );
  }

  Future<void> _createKanjiTable(Database db) async {
    await db.execute('''
      CREATE TABLE kanji (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        character TEXT NOT NULL,
        meaning TEXT NOT NULL,
        onyomi TEXT,
        kunyomi TEXT,
        radicals TEXT,
        strokes INTEGER NOT NULL,
        level TEXT NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX idx_kanji_level ON kanji(level)');
  }

  Future<void> _createCardProgressTable(Database db) async {
    await db.execute('''
      CREATE TABLE card_progress (
        deck TEXT NOT NULL,
        item_id INTEGER NOT NULL,
        easiness REAL NOT NULL,
        interval_days INTEGER NOT NULL,
        repetition_count INTEGER NOT NULL,
        lapse_count INTEGER NOT NULL,
        due_at TEXT NOT NULL,
        last_reviewed_at TEXT,
        PRIMARY KEY (deck, item_id)
      )
    ''');
  }

  Future<void> _createBookmarkTable(Database db) async {
    await db.execute('''
      CREATE TABLE bookmark (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kind TEXT NOT NULL,
        item_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        UNIQUE(kind, item_id) ON CONFLICT IGNORE
      )
    ''');
  }

  Future<void> _createBadgeTable(Database db) async {
    await db.execute('''
      CREATE TABLE badge (
        code TEXT PRIMARY KEY,
        earned_at TEXT NOT NULL
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

  Future<void> _seedVocabulary(Database db) async {
    final batch = db.batch();
    for (final v in vocabularySeedData) {
      batch.insert('vocabulary', v.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<void> _seedKanji(Database db) async {
    final batch = db.batch();
    for (final k in kanjiSeedData) {
      batch.insert('kanji', k.toMap());
    }
    await batch.commit(noResult: true);
  }
}
