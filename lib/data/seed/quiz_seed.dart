/// JLPT-style mock questions. Mirrors the format used by the JLPT mock screen.
/// Self-generated, not scraped.
class QuizQuestion {
  final String id;
  final String level;
  final String section; // 'vocab' | 'kanji' | 'grammar'
  final String prompt;
  final List<String> choices;
  final int answerIndex;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.level,
    required this.section,
    required this.prompt,
    required this.choices,
    required this.answerIndex,
    required this.explanation,
  });
}

const List<QuizQuestion> quizSeed = [
  QuizQuestion(
    id: 'n5_v1',
    level: 'N5',
    section: 'vocab',
    prompt: '何を _____ ますか。 (What will you eat?)',
    choices: ['たべ', 'のみ', 'いき', 'み'],
    answerIndex: 0,
    explanation: 'たべる = to eat → ますform: たべます。',
  ),
  QuizQuestion(
    id: 'n5_v2',
    level: 'N5',
    section: 'vocab',
    prompt: '駅 (えき) means…',
    choices: ['school', 'station', 'shop', 'home'],
    answerIndex: 1,
    explanation: '駅 = station (where trains stop).',
  ),
  QuizQuestion(
    id: 'n5_k1',
    level: 'N5',
    section: 'kanji',
    prompt: 'How do you read 山?',
    choices: ['かわ', 'やま', 'き', 'ひ'],
    answerIndex: 1,
    explanation: '山 = やま (mountain).',
  ),
  QuizQuestion(
    id: 'n5_k2',
    level: 'N5',
    section: 'kanji',
    prompt: 'Which kanji means "tree"?',
    choices: ['木', '本', '水', '土'],
    answerIndex: 0,
    explanation: '木 = tree / wood.',
  ),
  QuizQuestion(
    id: 'n5_g1',
    level: 'N5',
    section: 'grammar',
    prompt: '私 ___ 学生です。',
    choices: ['を', 'が', 'は', 'に'],
    answerIndex: 2,
    explanation: 'は marks the topic. "I am a student."',
  ),
  QuizQuestion(
    id: 'n5_g2',
    level: 'N5',
    section: 'grammar',
    prompt: '本を ___ 。',
    choices: ['よみます', 'たべます', 'いきます', 'みず'],
    answerIndex: 0,
    explanation: '本 (book) pairs with よむ → よみます (read).',
  ),
  QuizQuestion(
    id: 'n5_g3',
    level: 'N5',
    section: 'grammar',
    prompt: 'A: 元気ですか。 B: はい、___ です。',
    choices: ['元気', '名前', '安い', '高い'],
    answerIndex: 0,
    explanation: '元気 = healthy/well. Standard greeting reply.',
  ),
  QuizQuestion(
    id: 'n5_v3',
    level: 'N5',
    section: 'vocab',
    prompt: '今日 (きょう) means…',
    choices: ['yesterday', 'tomorrow', 'today', 'tonight'],
    answerIndex: 2,
    explanation: '今日 = today.',
  ),
  QuizQuestion(
    id: 'n5_v4',
    level: 'N5',
    section: 'vocab',
    prompt: 'How do you say "I drink water"?',
    choices: [
      '水を飲みます',
      'ご飯を食べます',
      '本を読みます',
      '学校へ行きます',
    ],
    answerIndex: 0,
    explanation: '水 (water) + を + 飲みます (drink).',
  ),
  QuizQuestion(
    id: 'n5_k3',
    level: 'N5',
    section: 'kanji',
    prompt: 'Which reading of 月 means "month"?',
    choices: ['つき', 'ゲツ/ガツ', 'ひ', 'ニチ'],
    answerIndex: 1,
    explanation:
        '月 has on\'yomi ゲツ/ガツ used in compounds like 一月 (January).',
  ),
];
