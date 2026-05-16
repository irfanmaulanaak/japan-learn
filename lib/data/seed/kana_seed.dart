import '../models/kana.dart';

// Gojuon — 46 hiragana + 46 katakana = 92 base kana.
// Dakuten/handakuten/yoon excluded; add later if needed.

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

final List<Kana> kanaSeedData = [
  ..._build(Kana.typeHiragana, _hiraganaChars),
  ..._build(Kana.typeKatakana, _katakanaChars),
];

class _Row {
  final String group;
  final List<String> romaji;
  const _Row(this.group, this.romaji);
}
