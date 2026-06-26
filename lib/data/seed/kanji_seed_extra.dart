import '../models/kanji.dart';

/// Additional common N5 kanji appended to the original ~80 to reach the full
/// ~103 N5 set. Kept separate so the DB upgrade path can insert only these
/// without touching existing rows (and their SRS progress).
const List<Kanji> kanjiExtraSeedData = [
  Kanji(character: '円', meaning: 'yen; circle', onyomi: 'エン', kunyomi: 'まる-い', radicals: '冂', strokes: 4, level: 'N5'),
  Kanji(character: '先', meaning: 'ahead; previous', onyomi: 'セン', kunyomi: 'さき', radicals: '儿', strokes: 6, level: 'N5'),
  Kanji(character: '語', meaning: 'language; word', onyomi: 'ゴ', kunyomi: 'かた-る', radicals: '言', strokes: 14, level: 'N5'),
  Kanji(character: '午', meaning: 'noon', onyomi: 'ゴ', kunyomi: '', radicals: '十', strokes: 4, level: 'N5'),
  Kanji(character: '毎', meaning: 'every', onyomi: 'マイ', kunyomi: '', radicals: '母', strokes: 6, level: 'N5'),
  Kanji(character: '間', meaning: 'interval; between', onyomi: 'カン, ケン', kunyomi: 'あいだ, ま', radicals: '門', strokes: 12, level: 'N5'),
  Kanji(character: '長', meaning: 'long; chief', onyomi: 'チョウ', kunyomi: 'なが-い', radicals: '長', strokes: 8, level: 'N5'),
  Kanji(character: '東', meaning: 'east', onyomi: 'トウ', kunyomi: 'ひがし', radicals: '木', strokes: 8, level: 'N5'),
  Kanji(character: '西', meaning: 'west', onyomi: 'セイ, サイ', kunyomi: 'にし', radicals: '西', strokes: 6, level: 'N5'),
  Kanji(character: '南', meaning: 'south', onyomi: 'ナン', kunyomi: 'みなみ', radicals: '十', strokes: 9, level: 'N5'),
  Kanji(character: '北', meaning: 'north', onyomi: 'ホク', kunyomi: 'きた', radicals: '匕', strokes: 5, level: 'N5'),
  Kanji(character: '白', meaning: 'white', onyomi: 'ハク', kunyomi: 'しろ-い', radicals: '白', strokes: 5, level: 'N5'),
  Kanji(character: '目', meaning: 'eye', onyomi: 'モク', kunyomi: 'め', radicals: '目', strokes: 5, level: 'N5'),
  Kanji(character: '口', meaning: 'mouth', onyomi: 'コウ', kunyomi: 'くち', radicals: '口', strokes: 3, level: 'N5'),
  Kanji(character: '手', meaning: 'hand', onyomi: 'シュ', kunyomi: 'て', radicals: '手', strokes: 4, level: 'N5'),
  Kanji(character: '足', meaning: 'foot; leg; suffice', onyomi: 'ソク', kunyomi: 'あし, た-りる', radicals: '足', strokes: 7, level: 'N5'),
  Kanji(character: '立', meaning: 'stand', onyomi: 'リツ', kunyomi: 'た-つ', radicals: '立', strokes: 5, level: 'N5'),
  Kanji(character: '天', meaning: 'heaven; sky', onyomi: 'テン', kunyomi: 'あめ', radicals: '大', strokes: 4, level: 'N5'),
  Kanji(character: '花', meaning: 'flower', onyomi: 'カ', kunyomi: 'はな', radicals: '艹', strokes: 7, level: 'N5'),
  Kanji(character: '力', meaning: 'power; strength', onyomi: 'リョク, リキ', kunyomi: 'ちから', radicals: '力', strokes: 2, level: 'N5'),
  Kanji(character: '文', meaning: 'sentence; writing', onyomi: 'ブン, モン', kunyomi: 'ふみ', radicals: '文', strokes: 4, level: 'N5'),
  Kanji(character: '字', meaning: 'character; letter', onyomi: 'ジ', kunyomi: 'あざ', radicals: '子', strokes: 6, level: 'N5'),
  Kanji(character: '雪', meaning: 'snow', onyomi: 'セツ', kunyomi: 'ゆき', radicals: '雨', strokes: 11, level: 'N5'),
  Kanji(character: '風', meaning: 'wind', onyomi: 'フウ', kunyomi: 'かぜ', radicals: '風', strokes: 9, level: 'N5'),
];
