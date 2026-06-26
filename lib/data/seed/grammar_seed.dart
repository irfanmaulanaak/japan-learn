/// Hand-written N5 grammar points. Self-generated, no scraping. Plain-language
/// explanations aimed at someone who has never studied Japanese, each with a
/// couple of example sentences (Japanese + English).
class GrammarExample {
  final String ja;
  final String en;
  const GrammarExample(this.ja, this.en);
}

class GrammarPoint {
  final String id;
  final String level;
  final String title;
  final String structure;
  final String explanation;
  final List<GrammarExample> examples;

  const GrammarPoint({
    required this.id,
    required this.level,
    required this.title,
    required this.structure,
    required this.explanation,
    required this.examples,
  });
}

const List<GrammarPoint> grammarSeed = [
  GrammarPoint(
    id: 'desu',
    level: 'N5',
    title: 'です — polite "to be"',
    structure: 'A は B です',
    explanation:
        'です sits at the end of a sentence to say "A is B" politely. It works '
        'with nouns and adjectives. It does not change for I / you / he — '
        'context tells you who. Negative is じゃありません.',
    examples: [
      GrammarExample('私は学生です。', 'I am a student.'),
      GrammarExample('これは水です。', 'This is water.'),
      GrammarExample('田中さんは先生じゃありません。', 'Tanaka is not a teacher.'),
    ],
  ),
  GrammarPoint(
    id: 'wa',
    level: 'N5',
    title: 'は — topic marker',
    structure: '〜は',
    explanation:
        'は (pronounced "wa" here) marks the topic — what the sentence is '
        'about. Think of it as "as for ___". The rest of the sentence comments '
        'on that topic.',
    examples: [
      GrammarExample('私は日本人です。', 'As for me, I am Japanese.'),
      GrammarExample('今日は暑いです。', 'Today is hot.'),
    ],
  ),
  GrammarPoint(
    id: 'ga',
    level: 'N5',
    title: 'が — subject marker (は vs が)',
    structure: '〜が',
    explanation:
        'が marks the subject, often new information or the answer to "who/what". '
        'Use は to set a known topic; use が to point out or introduce something. '
        '"誰がですか" asks who, and the answer takes が.',
    examples: [
      GrammarExample('猫がいます。', 'There is a cat. (introducing it)'),
      GrammarExample('私が行きます。', 'I am the one who will go.'),
    ],
  ),
  GrammarPoint(
    id: 'wo',
    level: 'N5',
    title: 'を — object marker',
    structure: '〜を + verb',
    explanation:
        'を (pronounced "o") marks the direct object — the thing the verb acts '
        'on. It comes right before the verb.',
    examples: [
      GrammarExample('水を飲みます。', 'I drink water.'),
      GrammarExample('本を読みます。', 'I read a book.'),
    ],
  ),
  GrammarPoint(
    id: 'ni',
    level: 'N5',
    title: 'に — time, destination, location',
    structure: '〜に',
    explanation:
        'に marks a point in time (七時に = at 7), a destination (学校に行く = go '
        'to school), or where something exists with あります/います.',
    examples: [
      GrammarExample('七時に起きます。', 'I wake up at seven.'),
      GrammarExample('部屋に猫がいます。', 'There is a cat in the room.'),
    ],
  ),
  GrammarPoint(
    id: 'de',
    level: 'N5',
    title: 'で — place of action / means',
    structure: '〜で',
    explanation:
        'で marks where an action happens (公園で遊ぶ = play at the park) or the '
        'means used (電車で行く = go by train). Compare with に, which marks '
        'existence or destination, not the action itself.',
    examples: [
      GrammarExample('図書館で勉強します。', 'I study at the library.'),
      GrammarExample('バスで帰ります。', 'I go home by bus.'),
    ],
  ),
  GrammarPoint(
    id: 'he',
    level: 'N5',
    title: 'へ — direction',
    structure: '〜へ',
    explanation:
        'へ (pronounced "e") marks the direction of movement. It overlaps with に '
        'for destinations; へ stresses the direction, に the arrival point.',
    examples: [
      GrammarExample('日本へ行きます。', 'I am going to Japan.'),
      GrammarExample('家へ帰ります。', 'I am heading home.'),
    ],
  ),
  GrammarPoint(
    id: 'no',
    level: 'N5',
    title: 'の — possession / linking nouns',
    structure: 'A の B',
    explanation:
        'の joins two nouns. A の B means "B of A" or "A\'s B". The owner or '
        'describer comes first.',
    examples: [
      GrammarExample('私の本です。', 'It is my book.'),
      GrammarExample('日本語の先生です。', 'A teacher of Japanese.'),
    ],
  ),
  GrammarPoint(
    id: 'to',
    level: 'N5',
    title: 'と — and / with',
    structure: 'A と B',
    explanation:
        'と links nouns in a complete list ("A and B") and also means "with" '
        'someone (友達と = with a friend).',
    examples: [
      GrammarExample('パンと卵を買います。', 'I buy bread and eggs.'),
      GrammarExample('友達と映画を見ます。', 'I watch a movie with a friend.'),
    ],
  ),
  GrammarPoint(
    id: 'mo',
    level: 'N5',
    title: 'も — also / too',
    structure: '〜も',
    explanation:
        'も replaces は or が to mean "also/too". It says the same thing is true '
        'for this item as well.',
    examples: [
      GrammarExample('私も学生です。', 'I am a student too.'),
      GrammarExample('これもください。', 'This one too, please.'),
    ],
  ),
  GrammarPoint(
    id: 'ka',
    level: 'N5',
    title: 'か — question marker',
    structure: '〜です + か',
    explanation:
        'Add か to the end of a statement to turn it into a question. No question '
        'mark or word-order change needed.',
    examples: [
      GrammarExample('学生ですか。', 'Are you a student?'),
      GrammarExample('水を飲みますか。', 'Do you drink water?'),
    ],
  ),
  GrammarPoint(
    id: 'masu',
    level: 'N5',
    title: 'ます / ません — polite verbs (non-past)',
    structure: 'verb-ます / verb-ません',
    explanation:
        'The ます form is the polite present/future. たべます = eat / will eat. '
        'The negative swaps ます for ません: たべません = do not / will not eat.',
    examples: [
      GrammarExample('毎日勉強します。', 'I study every day.'),
      GrammarExample('お酒を飲みません。', 'I do not drink alcohol.'),
    ],
  ),
  GrammarPoint(
    id: 'mashita',
    level: 'N5',
    title: 'ました / ませんでした — polite past',
    structure: 'verb-ました / verb-ませんでした',
    explanation:
        'For the polite past, ます becomes ました (did) and ません becomes '
        'ませんでした (did not).',
    examples: [
      GrammarExample('映画を見ました。', 'I watched a movie.'),
      GrammarExample('昨日は来ませんでした。', 'I did not come yesterday.'),
    ],
  ),
  GrammarPoint(
    id: 'i-adj',
    level: 'N5',
    title: 'い-adjectives',
    structure: 'い-adj + noun / + です',
    explanation:
        'い-adjectives end in い and go straight before a noun (高い山 = tall '
        'mountain) or before です. Negative: drop い, add くないです '
        '(高い → 高くないです).',
    examples: [
      GrammarExample('新しい車です。', 'It is a new car.'),
      GrammarExample('この本は高くないです。', 'This book is not expensive.'),
    ],
  ),
  GrammarPoint(
    id: 'na-adj',
    level: 'N5',
    title: 'な-adjectives',
    structure: 'な-adj + な + noun / + です',
    explanation:
        'な-adjectives need な before a noun (静かな町 = quiet town) but nothing '
        'extra before です (静かです). Negative: じゃありません.',
    examples: [
      GrammarExample('便利な店です。', 'It is a convenient shop.'),
      GrammarExample('ここは静かじゃありません。', 'It is not quiet here.'),
    ],
  ),
  GrammarPoint(
    id: 'kosoado',
    level: 'N5',
    title: 'これ・それ・あれ — this / that',
    structure: 'これ / それ / あれ',
    explanation:
        'これ = near me, それ = near you, あれ = away from both. For "this ___ '
        '(noun)" use この / その / あの before the noun.',
    examples: [
      GrammarExample('これは何ですか。', 'What is this?'),
      GrammarExample('あの人は先生です。', 'That person is a teacher.'),
    ],
  ),
  GrammarPoint(
    id: 'tai',
    level: 'N5',
    title: '〜たいです — want to do',
    structure: 'verb-stem + たいです',
    explanation:
        'Drop ます and add たいです to say you want to do something. '
        'たべます → たべたいです = want to eat.',
    examples: [
      GrammarExample('日本へ行きたいです。', 'I want to go to Japan.'),
      GrammarExample('水が飲みたいです。', 'I want to drink water.'),
    ],
  ),
  GrammarPoint(
    id: 'tekudasai',
    level: 'N5',
    title: '〜てください — please do',
    structure: 'verb-て + ください',
    explanation:
        'The て-form plus ください makes a polite request. たべて → たべてください '
        '= please eat. Useful for asking someone to do something.',
    examples: [
      GrammarExample('ここに名前を書いてください。', 'Please write your name here.'),
      GrammarExample('もう一度言ってください。', 'Please say it once more.'),
    ],
  ),
  GrammarPoint(
    id: 'mashou',
    level: 'N5',
    title: '〜ましょう / 〜ませんか — suggest / invite',
    structure: 'verb-ましょう / verb-ませんか',
    explanation:
        'ましょう = "let\'s ___". ませんか = a softer "won\'t you ___?" used to '
        'invite. Both build on the ます stem.',
    examples: [
      GrammarExample('一緒に行きましょう。', "Let's go together."),
      GrammarExample('お茶を飲みませんか。', 'Would you like to drink some tea?'),
    ],
  ),
  GrammarPoint(
    id: 'kara',
    level: 'N5',
    title: '〜から — because',
    structure: 'reason + から、result',
    explanation:
        'から after a sentence gives a reason: "because ___". The reason comes '
        'first, then から, then the result.',
    examples: [
      GrammarExample('忙しいから、行きません。', 'I will not go because I am busy.'),
      GrammarExample('安いから、買います。', 'I will buy it because it is cheap.'),
    ],
  ),
];
