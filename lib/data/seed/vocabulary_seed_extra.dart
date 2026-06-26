import '../models/vocabulary.dart';

/// Additional high-frequency N5 vocabulary appended to the original core set.
/// Kept separate so the DB upgrade path inserts only these without disturbing
/// existing rows or their SRS progress. One entry per line for density.
const List<Vocabulary> vocabularyExtraSeedData = [
  // Time & calendar
  Vocabulary(word: '今', reading: 'いま', meaning: 'now', partOfSpeech: 'noun', level: 'N5', exampleJa: '今、何時ですか。', exampleEn: 'What time is it now?'),
  Vocabulary(word: '午前', reading: 'ごぜん', meaning: 'morning; a.m.', partOfSpeech: 'noun', level: 'N5', exampleJa: '午前九時に会いましょう。', exampleEn: "Let's meet at 9 a.m."),
  Vocabulary(word: '午後', reading: 'ごご', meaning: 'afternoon; p.m.', partOfSpeech: 'noun', level: 'N5', exampleJa: '午後は忙しいです。', exampleEn: 'I am busy in the afternoon.'),
  Vocabulary(word: '毎日', reading: 'まいにち', meaning: 'every day', partOfSpeech: 'noun', level: 'N5', exampleJa: '毎日日本語を勉強します。', exampleEn: 'I study Japanese every day.'),
  Vocabulary(word: '今週', reading: 'こんしゅう', meaning: 'this week', partOfSpeech: 'noun', level: 'N5', exampleJa: '今週は雨が多いです。', exampleEn: 'There is a lot of rain this week.'),
  Vocabulary(word: '来週', reading: 'らいしゅう', meaning: 'next week', partOfSpeech: 'noun', level: 'N5', exampleJa: '来週、京都へ行きます。', exampleEn: 'I will go to Kyoto next week.'),
  Vocabulary(word: '月曜日', reading: 'げつようび', meaning: 'Monday', partOfSpeech: 'noun', level: 'N5', exampleJa: '月曜日に学校が始まります。', exampleEn: 'School starts on Monday.'),
  Vocabulary(word: '火曜日', reading: 'かようび', meaning: 'Tuesday', partOfSpeech: 'noun', level: 'N5', exampleJa: '火曜日は休みです。', exampleEn: 'Tuesday is a day off.'),
  Vocabulary(word: '水曜日', reading: 'すいようび', meaning: 'Wednesday', partOfSpeech: 'noun', level: 'N5', exampleJa: '水曜日に会議があります。', exampleEn: 'There is a meeting on Wednesday.'),
  Vocabulary(word: '木曜日', reading: 'もくようび', meaning: 'Thursday', partOfSpeech: 'noun', level: 'N5', exampleJa: '木曜日まで待ってください。', exampleEn: 'Please wait until Thursday.'),
  Vocabulary(word: '金曜日', reading: 'きんようび', meaning: 'Friday', partOfSpeech: 'noun', level: 'N5', exampleJa: '金曜日の夜は映画を見ます。', exampleEn: 'I watch movies on Friday night.'),
  Vocabulary(word: '土曜日', reading: 'どようび', meaning: 'Saturday', partOfSpeech: 'noun', level: 'N5', exampleJa: '土曜日に友達と遊びます。', exampleEn: 'I hang out with friends on Saturday.'),
  Vocabulary(word: '日曜日', reading: 'にちようび', meaning: 'Sunday', partOfSpeech: 'noun', level: 'N5', exampleJa: '日曜日は家にいます。', exampleEn: 'I stay home on Sunday.'),

  // Places
  Vocabulary(word: 'お金', reading: 'おかね', meaning: 'money', partOfSpeech: 'noun', level: 'N5', exampleJa: 'お金がありません。', exampleEn: 'I have no money.'),
  Vocabulary(word: '店', reading: 'みせ', meaning: 'shop; store', partOfSpeech: 'noun', level: 'N5', exampleJa: 'あの店は安いです。', exampleEn: 'That shop is cheap.'),
  Vocabulary(word: '会社', reading: 'かいしゃ', meaning: 'company', partOfSpeech: 'noun', level: 'N5', exampleJa: '父は会社で働いています。', exampleEn: 'My father works at a company.'),
  Vocabulary(word: '部屋', reading: 'へや', meaning: 'room', partOfSpeech: 'noun', level: 'N5', exampleJa: '部屋が綺麗です。', exampleEn: 'The room is clean.'),
  Vocabulary(word: '病院', reading: 'びょういん', meaning: 'hospital', partOfSpeech: 'noun', level: 'N5', exampleJa: '病院はどこですか。', exampleEn: 'Where is the hospital?'),
  Vocabulary(word: '銀行', reading: 'ぎんこう', meaning: 'bank', partOfSpeech: 'noun', level: 'N5', exampleJa: '銀行でお金を出します。', exampleEn: 'I withdraw money at the bank.'),
  Vocabulary(word: '図書館', reading: 'としょかん', meaning: 'library', partOfSpeech: 'noun', level: 'N5', exampleJa: '図書館で本を読みます。', exampleEn: 'I read books at the library.'),
  Vocabulary(word: '公園', reading: 'こうえん', meaning: 'park', partOfSpeech: 'noun', level: 'N5', exampleJa: '公園を散歩します。', exampleEn: 'I take a walk in the park.'),
  Vocabulary(word: '大学', reading: 'だいがく', meaning: 'university', partOfSpeech: 'noun', level: 'N5', exampleJa: '姉は大学の学生です。', exampleEn: 'My older sister is a university student.'),
  Vocabulary(word: '教室', reading: 'きょうしつ', meaning: 'classroom', partOfSpeech: 'noun', level: 'N5', exampleJa: '教室に学生が三人います。', exampleEn: 'There are three students in the classroom.'),

  // Body
  Vocabulary(word: '体', reading: 'からだ', meaning: 'body', partOfSpeech: 'noun', level: 'N5', exampleJa: '体に気をつけてください。', exampleEn: 'Please take care of your body.'),
  Vocabulary(word: '頭', reading: 'あたま', meaning: 'head', partOfSpeech: 'noun', level: 'N5', exampleJa: '頭が痛いです。', exampleEn: 'My head hurts.'),
  Vocabulary(word: '顔', reading: 'かお', meaning: 'face', partOfSpeech: 'noun', level: 'N5', exampleJa: '朝、顔を洗います。', exampleEn: 'I wash my face in the morning.'),
  Vocabulary(word: '目', reading: 'め', meaning: 'eye', partOfSpeech: 'noun', level: 'N5', exampleJa: '目が大きいです。', exampleEn: 'The eyes are big.'),
  Vocabulary(word: '耳', reading: 'みみ', meaning: 'ear', partOfSpeech: 'noun', level: 'N5', exampleJa: '耳が痛いです。', exampleEn: 'My ear hurts.'),
  Vocabulary(word: '口', reading: 'くち', meaning: 'mouth', partOfSpeech: 'noun', level: 'N5', exampleJa: '口を開けてください。', exampleEn: 'Please open your mouth.'),
  Vocabulary(word: '手', reading: 'て', meaning: 'hand', partOfSpeech: 'noun', level: 'N5', exampleJa: '手を洗いましょう。', exampleEn: "Let's wash our hands."),
  Vocabulary(word: '足', reading: 'あし', meaning: 'foot; leg', partOfSpeech: 'noun', level: 'N5', exampleJa: '足が疲れました。', exampleEn: 'My legs are tired.'),

  // Food & drink
  Vocabulary(word: 'ご飯', reading: 'ごはん', meaning: 'cooked rice; meal', partOfSpeech: 'noun', level: 'N5', exampleJa: 'ご飯を食べましょう。', exampleEn: "Let's eat."),
  Vocabulary(word: 'パン', reading: 'パン', meaning: 'bread', partOfSpeech: 'noun', level: 'N5', exampleJa: '朝はパンを食べます。', exampleEn: 'I eat bread in the morning.'),
  Vocabulary(word: '肉', reading: 'にく', meaning: 'meat', partOfSpeech: 'noun', level: 'N5', exampleJa: '肉が好きです。', exampleEn: 'I like meat.'),
  Vocabulary(word: '魚', reading: 'さかな', meaning: 'fish', partOfSpeech: 'noun', level: 'N5', exampleJa: '魚を食べますか。', exampleEn: 'Do you eat fish?'),
  Vocabulary(word: '野菜', reading: 'やさい', meaning: 'vegetable', partOfSpeech: 'noun', level: 'N5', exampleJa: '野菜は体にいいです。', exampleEn: 'Vegetables are good for the body.'),
  Vocabulary(word: '卵', reading: 'たまご', meaning: 'egg', partOfSpeech: 'noun', level: 'N5', exampleJa: '卵を二つ買いました。', exampleEn: 'I bought two eggs.'),
  Vocabulary(word: 'お茶', reading: 'おちゃ', meaning: 'tea', partOfSpeech: 'noun', level: 'N5', exampleJa: 'お茶を飲みませんか。', exampleEn: 'Would you like some tea?'),
  Vocabulary(word: '果物', reading: 'くだもの', meaning: 'fruit', partOfSpeech: 'noun', level: 'N5', exampleJa: '果物が大好きです。', exampleEn: 'I love fruit.'),

  // People
  Vocabulary(word: '子供', reading: 'こども', meaning: 'child', partOfSpeech: 'noun', level: 'N5', exampleJa: '公園に子供が多いです。', exampleEn: 'There are many children in the park.'),
  Vocabulary(word: '男', reading: 'おとこ', meaning: 'man; male', partOfSpeech: 'noun', level: 'N5', exampleJa: 'あの男の人は先生です。', exampleEn: 'That man is a teacher.'),
  Vocabulary(word: '女', reading: 'おんな', meaning: 'woman; female', partOfSpeech: 'noun', level: 'N5', exampleJa: '女の人が二人います。', exampleEn: 'There are two women.'),

  // Verbs
  Vocabulary(word: 'する', reading: 'する', meaning: 'to do', partOfSpeech: 'verb', level: 'N5', exampleJa: '今、何をしていますか。', exampleEn: 'What are you doing now?'),
  Vocabulary(word: 'ある', reading: 'ある', meaning: 'to exist (things)', partOfSpeech: 'verb', level: 'N5', exampleJa: '机の上に本があります。', exampleEn: 'There is a book on the desk.'),
  Vocabulary(word: 'いる', reading: 'いる', meaning: 'to exist (people/animals)', partOfSpeech: 'verb', level: 'N5', exampleJa: '部屋に猫がいます。', exampleEn: 'There is a cat in the room.'),
  Vocabulary(word: '言う', reading: 'いう', meaning: 'to say', partOfSpeech: 'verb', level: 'N5', exampleJa: 'もう一度言ってください。', exampleEn: 'Please say it once more.'),
  Vocabulary(word: '思う', reading: 'おもう', meaning: 'to think', partOfSpeech: 'verb', level: 'N5', exampleJa: 'いいと思います。', exampleEn: 'I think it is good.'),
  Vocabulary(word: '待つ', reading: 'まつ', meaning: 'to wait', partOfSpeech: 'verb', level: 'N5', exampleJa: 'ここで待ってください。', exampleEn: 'Please wait here.'),
  Vocabulary(word: '立つ', reading: 'たつ', meaning: 'to stand', partOfSpeech: 'verb', level: 'N5', exampleJa: '立ってください。', exampleEn: 'Please stand up.'),
  Vocabulary(word: '座る', reading: 'すわる', meaning: 'to sit', partOfSpeech: 'verb', level: 'N5', exampleJa: 'ここに座ってもいいですか。', exampleEn: 'May I sit here?'),
  Vocabulary(word: '歩く', reading: 'あるく', meaning: 'to walk', partOfSpeech: 'verb', level: 'N5', exampleJa: '駅まで歩きます。', exampleEn: 'I walk to the station.'),
  Vocabulary(word: '走る', reading: 'はしる', meaning: 'to run', partOfSpeech: 'verb', level: 'N5', exampleJa: '毎朝、公園を走ります。', exampleEn: 'I run in the park every morning.'),
  Vocabulary(word: '入る', reading: 'はいる', meaning: 'to enter', partOfSpeech: 'verb', level: 'N5', exampleJa: '部屋に入ってください。', exampleEn: 'Please enter the room.'),
  Vocabulary(word: '出る', reading: 'でる', meaning: 'to leave; go out', partOfSpeech: 'verb', level: 'N5', exampleJa: '七時に家を出ます。', exampleEn: 'I leave the house at seven.'),
  Vocabulary(word: '乗る', reading: 'のる', meaning: 'to ride; get on', partOfSpeech: 'verb', level: 'N5', exampleJa: '電車に乗ります。', exampleEn: 'I get on the train.'),
  Vocabulary(word: '使う', reading: 'つかう', meaning: 'to use', partOfSpeech: 'verb', level: 'N5', exampleJa: 'この辞書を使ってください。', exampleEn: 'Please use this dictionary.'),
  Vocabulary(word: '教える', reading: 'おしえる', meaning: 'to teach; tell', partOfSpeech: 'verb', level: 'N5', exampleJa: '名前を教えてください。', exampleEn: 'Please tell me your name.'),
  Vocabulary(word: '分かる', reading: 'わかる', meaning: 'to understand', partOfSpeech: 'verb', level: 'N5', exampleJa: '日本語が少し分かります。', exampleEn: 'I understand a little Japanese.'),
  Vocabulary(word: '持つ', reading: 'もつ', meaning: 'to hold; have', partOfSpeech: 'verb', level: 'N5', exampleJa: 'かばんを持っています。', exampleEn: 'I am holding a bag.'),
  Vocabulary(word: '遊ぶ', reading: 'あそぶ', meaning: 'to play; hang out', partOfSpeech: 'verb', level: 'N5', exampleJa: '友達と遊びます。', exampleEn: 'I hang out with friends.'),

  // i-adjectives
  Vocabulary(word: '長い', reading: 'ながい', meaning: 'long', partOfSpeech: 'adjective', level: 'N5', exampleJa: 'この川は長いです。', exampleEn: 'This river is long.'),
  Vocabulary(word: '短い', reading: 'みじかい', meaning: 'short', partOfSpeech: 'adjective', level: 'N5', exampleJa: '髪が短いです。', exampleEn: 'The hair is short.'),
  Vocabulary(word: '多い', reading: 'おおい', meaning: 'many; a lot', partOfSpeech: 'adjective', level: 'N5', exampleJa: '人が多いです。', exampleEn: 'There are many people.'),
  Vocabulary(word: '少ない', reading: 'すくない', meaning: 'few; little', partOfSpeech: 'adjective', level: 'N5', exampleJa: 'お金が少ないです。', exampleEn: 'I have little money.'),
  Vocabulary(word: '早い', reading: 'はやい', meaning: 'early', partOfSpeech: 'adjective', level: 'N5', exampleJa: '朝は早いです。', exampleEn: 'The mornings are early.'),
  Vocabulary(word: '速い', reading: 'はやい', meaning: 'fast', partOfSpeech: 'adjective', level: 'N5', exampleJa: 'この電車は速いです。', exampleEn: 'This train is fast.'),
  Vocabulary(word: '遅い', reading: 'おそい', meaning: 'late; slow', partOfSpeech: 'adjective', level: 'N5', exampleJa: '今日は帰りが遅いです。', exampleEn: 'I am coming home late today.'),
  Vocabulary(word: '近い', reading: 'ちかい', meaning: 'near; close', partOfSpeech: 'adjective', level: 'N5', exampleJa: '駅は家から近いです。', exampleEn: 'The station is close to my house.'),
  Vocabulary(word: '遠い', reading: 'とおい', meaning: 'far', partOfSpeech: 'adjective', level: 'N5', exampleJa: '学校は遠いです。', exampleEn: 'The school is far.'),
  Vocabulary(word: '楽しい', reading: 'たのしい', meaning: 'fun; enjoyable', partOfSpeech: 'adjective', level: 'N5', exampleJa: '日本語の勉強は楽しいです。', exampleEn: 'Studying Japanese is fun.'),
  Vocabulary(word: '面白い', reading: 'おもしろい', meaning: 'interesting; funny', partOfSpeech: 'adjective', level: 'N5', exampleJa: 'この本は面白いです。', exampleEn: 'This book is interesting.'),
  Vocabulary(word: '難しい', reading: 'むずかしい', meaning: 'difficult', partOfSpeech: 'adjective', level: 'N5', exampleJa: '漢字は難しいです。', exampleEn: 'Kanji is difficult.'),
  Vocabulary(word: '忙しい', reading: 'いそがしい', meaning: 'busy', partOfSpeech: 'adjective', level: 'N5', exampleJa: '今日はとても忙しいです。', exampleEn: 'I am very busy today.'),

  // na-adjectives & misc
  Vocabulary(word: '有名', reading: 'ゆうめい', meaning: 'famous', partOfSpeech: 'na-adjective', level: 'N5', exampleJa: 'この店は有名です。', exampleEn: 'This shop is famous.'),
  Vocabulary(word: '親切', reading: 'しんせつ', meaning: 'kind', partOfSpeech: 'na-adjective', level: 'N5', exampleJa: '先生は親切です。', exampleEn: 'The teacher is kind.'),
  Vocabulary(word: '大切', reading: 'たいせつ', meaning: 'important; precious', partOfSpeech: 'na-adjective', level: 'N5', exampleJa: '家族は大切です。', exampleEn: 'Family is important.'),
  Vocabulary(word: '簡単', reading: 'かんたん', meaning: 'simple; easy', partOfSpeech: 'na-adjective', level: 'N5', exampleJa: 'このテストは簡単です。', exampleEn: 'This test is easy.'),
  Vocabulary(word: '大変', reading: 'たいへん', meaning: 'tough; hard', partOfSpeech: 'na-adjective', level: 'N5', exampleJa: '仕事は大変です。', exampleEn: 'The work is tough.'),
  Vocabulary(word: '天気', reading: 'てんき', meaning: 'weather', partOfSpeech: 'noun', level: 'N5', exampleJa: '今日はいい天気です。', exampleEn: 'The weather is nice today.'),
  Vocabulary(word: '色', reading: 'いろ', meaning: 'color', partOfSpeech: 'noun', level: 'N5', exampleJa: '好きな色は青です。', exampleEn: 'My favorite color is blue.'),
];
