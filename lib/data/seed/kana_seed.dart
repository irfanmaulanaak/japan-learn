import '../models/kana.dart';

// Gojuon base — 46 hiragana + 46 katakana = 92 base kana.
// Extended sets (dakuten / handakuten / yoon) are appended below so a real
// learner can read actual Japanese, not just the unvoiced base grid.

const _rows = <_Row>[
  _Row('a', ['a', 'i', 'u', 'e', 'o']),
  _Row('ka', ['ka', 'ki', 'ku', 'ke', 'ko']),
  _Row('sa', ['sa', 'shi', 'su', 'se', 'so']),
  _Row('ta', ['ta', 'chi', 'tsu', 'te', 'to']),
  _Row('na', ['na', 'ni', 'nu', 'ne', 'no']),
  _Row('ha', ['ha', 'hi', 'fu', 'he', 'ho']),
  _Row('ma', ['ma', 'mi', 'mu', 'me', 'mo']),
  _Row('ya', ['ya', 'yu', 'yo']),
  _Row('ra', ['ra', 'ri', 'ru', 're', 'ro']),
  _Row('wa', ['wa', 'wo']),
  _Row('n', ['n']),
];

const _hiraganaChars = [
  'あ', 'い', 'う', 'え', 'お',
  'か', 'き', 'く', 'け', 'こ',
  'さ', 'し', 'す', 'せ', 'そ',
  'た', 'ち', 'つ', 'て', 'と',
  'な', 'に', 'ぬ', 'ね', 'の',
  'は', 'ひ', 'ふ', 'へ', 'ほ',
  'ま', 'み', 'む', 'め', 'も',
  'や', 'ゆ', 'よ',
  'ら', 'り', 'る', 'れ', 'ろ',
  'わ', 'を',
  'ん',
];

const _katakanaChars = [
  'ア', 'イ', 'ウ', 'エ', 'オ',
  'カ', 'キ', 'ク', 'ケ', 'コ',
  'サ', 'シ', 'ス', 'セ', 'ソ',
  'タ', 'チ', 'ツ', 'テ', 'ト',
  'ナ', 'ニ', 'ヌ', 'ネ', 'ノ',
  'ハ', 'ヒ', 'フ', 'ヘ', 'ホ',
  'マ', 'ミ', 'ム', 'メ', 'モ',
  'ヤ', 'ユ', 'ヨ',
  'ラ', 'リ', 'ル', 'レ', 'ロ',
  'ワ', 'ヲ',
  'ン',
];

// Dakuten / handakuten / yoon. Each row carries both scripts so we stay in
// sync. Romaji follows Hepburn (し→shi, しゃ→sha, じ→ji …).
const _extRows = <_ExtRow>[
  // Dakuten
  _ExtRow('ga', ['が', 'ぎ', 'ぐ', 'げ', 'ご'], ['ガ', 'ギ', 'グ', 'ゲ', 'ゴ'], ['ga', 'gi', 'gu', 'ge', 'go']),
  _ExtRow('za', ['ざ', 'じ', 'ず', 'ぜ', 'ぞ'], ['ザ', 'ジ', 'ズ', 'ゼ', 'ゾ'], ['za', 'ji', 'zu', 'ze', 'zo']),
  _ExtRow('da', ['だ', 'ぢ', 'づ', 'で', 'ど'], ['ダ', 'ヂ', 'ヅ', 'デ', 'ド'], ['da', 'ji', 'zu', 'de', 'do']),
  _ExtRow('ba', ['ば', 'び', 'ぶ', 'べ', 'ぼ'], ['バ', 'ビ', 'ブ', 'ベ', 'ボ'], ['ba', 'bi', 'bu', 'be', 'bo']),
  // Handakuten
  _ExtRow('pa', ['ぱ', 'ぴ', 'ぷ', 'ぺ', 'ぽ'], ['パ', 'ピ', 'プ', 'ペ', 'ポ'], ['pa', 'pi', 'pu', 'pe', 'po']),
  // Yoon
  _ExtRow('kya', ['きゃ', 'きゅ', 'きょ'], ['キャ', 'キュ', 'キョ'], ['kya', 'kyu', 'kyo']),
  _ExtRow('sha', ['しゃ', 'しゅ', 'しょ'], ['シャ', 'シュ', 'ショ'], ['sha', 'shu', 'sho']),
  _ExtRow('cha', ['ちゃ', 'ちゅ', 'ちょ'], ['チャ', 'チュ', 'チョ'], ['cha', 'chu', 'cho']),
  _ExtRow('nya', ['にゃ', 'にゅ', 'にょ'], ['ニャ', 'ニュ', 'ニョ'], ['nya', 'nyu', 'nyo']),
  _ExtRow('hya', ['ひゃ', 'ひゅ', 'ひょ'], ['ヒャ', 'ヒュ', 'ヒョ'], ['hya', 'hyu', 'hyo']),
  _ExtRow('mya', ['みゃ', 'みゅ', 'みょ'], ['ミャ', 'ミュ', 'ミョ'], ['mya', 'myu', 'myo']),
  _ExtRow('rya', ['りゃ', 'りゅ', 'りょ'], ['リャ', 'リュ', 'リョ'], ['rya', 'ryu', 'ryo']),
  _ExtRow('gya', ['ぎゃ', 'ぎゅ', 'ぎょ'], ['ギャ', 'ギュ', 'ギョ'], ['gya', 'gyu', 'gyo']),
  _ExtRow('ja', ['じゃ', 'じゅ', 'じょ'], ['ジャ', 'ジュ', 'ジョ'], ['ja', 'ju', 'jo']),
  _ExtRow('bya', ['びゃ', 'びゅ', 'びょ'], ['ビャ', 'ビュ', 'ビョ'], ['bya', 'byu', 'byo']),
  _ExtRow('pya', ['ぴゃ', 'ぴゅ', 'ぴょ'], ['ピャ', 'ピュ', 'ピョ'], ['pya', 'pyu', 'pyo']),
];

List<Kana> _build(String type, List<String> chars) {
  final out = <Kana>[];
  var i = 0;
  for (final row in _rows) {
    for (var j = 0; j < row.romaji.length; j++) {
      out.add(Kana(
        character: chars[i],
        romaji: row.romaji[j],
        type: type,
        rowGroup: row.group,
        orderIndex: j,
      ));
      i++;
    }
  }
  return out;
}

List<Kana> _buildExtended(String type) {
  final isHira = type == Kana.typeHiragana;
  final out = <Kana>[];
  for (final row in _extRows) {
    final chars = isHira ? row.hiragana : row.katakana;
    for (var j = 0; j < row.romaji.length; j++) {
      out.add(Kana(
        character: chars[j],
        romaji: row.romaji[j],
        type: type,
        rowGroup: row.group,
        orderIndex: j,
      ));
    }
  }
  return out;
}

/// Extended kana only (dakuten / handakuten / yoon). Kept separate so the DB
/// upgrade path can append these to installs that already seeded the 92 base.
final List<Kana> kanaExtendedSeedData = [
  ..._buildExtended(Kana.typeHiragana),
  ..._buildExtended(Kana.typeKatakana),
];

/// Full kana set used on a fresh install: base grid first, then extended.
final List<Kana> kanaSeedData = [
  ..._build(Kana.typeHiragana, _hiraganaChars),
  ..._build(Kana.typeKatakana, _katakanaChars),
  ...kanaExtendedSeedData,
];

class _Row {
  final String group;
  final List<String> romaji;
  const _Row(this.group, this.romaji);
}

class _ExtRow {
  final String group;
  final List<String> hiragana;
  final List<String> katakana;
  final List<String> romaji;
  const _ExtRow(this.group, this.hiragana, this.katakana, this.romaji);
}
