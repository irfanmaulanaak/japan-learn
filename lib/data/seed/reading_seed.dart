/// Hand-written graded reading passages. Self-generated, no scraping.
class ReadingPassage {
  final String id;
  final String level;
  final String title;
  final String body;
  final String translation;
  final int xpReward;

  const ReadingPassage({
    required this.id,
    required this.level,
    required this.title,
    required this.body,
    required this.translation,
    required this.xpReward,
  });
}

const List<ReadingPassage> readingPassages = [
  ReadingPassage(
    id: 'n5_morning',
    level: 'N5',
    title: 'あさのこうえん',
    body:
        '私は毎朝、近くの公園を歩きます。'
        '木が大きくて、鳥の声がよく聞こえます。'
        '時々、犬と一緒に来る人もいます。'
        '空気がきれいで、気持ちがいいです。',
    translation:
        'I walk in the nearby park every morning. '
        'The trees are big and you can hear the birds clearly. '
        'Sometimes people come with their dogs. '
        'The air is clean and it feels nice.',
    xpReward: 15,
  ),
  ReadingPassage(
    id: 'n5_breakfast',
    level: 'N5',
    title: 'あさごはん',
    body:
        '今日は七時に起きました。'
        '朝ご飯はパンと卵とコーヒーです。'
        '新聞を少し読んでから、家を出ました。'
        '駅まで歩いて十分かかります。',
    translation:
        'Today I woke up at 7. '
        'My breakfast was bread, eggs, and coffee. '
        'I read the newspaper a little and then left the house. '
        'It takes 10 minutes to walk to the station.',
    xpReward: 15,
  ),
  ReadingPassage(
    id: 'n5_weekend',
    level: 'N5',
    title: 'しゅうまつ',
    body:
        '土曜日は友達と映画を見ました。'
        'とても面白かったです。'
        '映画の後、近くのレストランでご飯を食べました。'
        '日曜日は家でゆっくり本を読みました。',
    translation:
        'On Saturday I watched a movie with a friend. '
        'It was very interesting. '
        'After the movie, we ate at a nearby restaurant. '
        'On Sunday I relaxed at home and read a book.',
    xpReward: 20,
  ),
  ReadingPassage(
    id: 'n4_train',
    level: 'N4',
    title: 'でんしゃのなかで',
    body:
        '昨日、仕事の帰りに電車の中で本を読んでいました。'
        'となりに座っていた女の人が、突然「すみません、駅はどこですか」と聞きました。'
        '私はその駅をよく知っているので、丁寧に教えてあげました。'
        '少しだけ親切な気持ちになりました。',
    translation:
        'Yesterday, on my way home from work, I was reading a book on the train. '
        'The woman sitting next to me suddenly asked, "Excuse me, where is the station?" '
        'I knew that station well, so I politely told her. '
        'It made me feel a little kinder.',
    xpReward: 30,
  ),
];
