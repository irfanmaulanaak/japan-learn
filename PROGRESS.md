# Progress

Track of what's built, what's mocked, what's next. Read `PLAN.md` for the spec; this file is the current state.

## Status
**Phases 1–3 wired end-to-end.** All modules from `PLAN.md` are playable with seeded N5 content. Phase 4 ships an entry-point only (Anki import scaffolded, cloud sync intentionally deferred to honour the offline-first architecture).

**P0 learning pass:** added on-device TTS audio across kana / vocab / kanji / shadowing / grammar; expanded kana with dakuten + handakuten + yoon; grew content to ~173 N5 vocab and ~103 N5 kanji; added a Grammar module (20 explained N5 patterns with audio examples); capped onboarding to N5 (N4–N1 marked "soon"). DB schema bumped to v7 (additive re-seed preserves existing SRS progress).

**P1 stickiness pass (latest):** added real *recall/production* practice — a typed-romaji "Recall" tab for kana (auto-graded, accepts common spellings) and a JP→EN / EN→JP direction toggle on vocab & kanji flashcards (recall the word from its meaning). Made kanji-by-radical real: a radical glossary (plain-English component meanings) + a tappable kanji detail screen (component breakdown, readings, and example words that use the kanji, all with audio) reachable from both the radical grid and the kanji browse list. Streak polish: streak freezes auto-cover one missed day (earned every 5-day streak, capped at 2) so a single slip no longer resets a long streak; shown on the profile. DB schema bumped to v8 (adds `freeze_tokens`, default 0 — existing streaks unaffected).

## Done

### Foundation
- [x] Flutter project (Android + iOS + macOS + Linux + Windows + web targets)
- [x] Riverpod + sqflite + shared_preferences
- [x] GitHub Actions APK build workflow
- [x] Android org `dev.irfanmaulanaak`
- [x] `flutter analyze`, `flutter test`, `flutter build apk` (debug + release) all green

### Data layer
- [x] SQLite helper at schema v8 (`lib/data/database/database_helper.dart`) — kana / user_goal / user_progress (+ `freeze_tokens`) / kana_progress / vocabulary / kanji / card_progress / bookmark / badge
- [x] Generic SM-2 engine `lib/data/srs/sm2.dart` reused by kana, vocab and kanji decks
- [x] Models: `Kana`, `KanaProgress`, `UserGoal` (+ `AdaptiveDailyPlan`), `UserProgress`, `Vocabulary`, `Kanji`, `CardProgress`, `Bookmark`, `EarnedBadge` / `BadgeCatalog`
- [x] Repositories: kana, kana_progress, vocabulary, kanji, card_progress, bookmark, badge, user_goal, user_progress
- [x] Seeds bundled in APK: full hiragana + katakana (base + dakuten/handakuten/yoon), ~173 N5 vocab, ~103 N5 kanji, 20 N5 grammar points, 4 graded reading passages, 10 JLPT mock questions
- [x] On-device TTS (`flutter_tts`) via `TtsService` / `ttsServiceProvider`; `SpeakButton` drops audio into kana flashcards, kana browse (tap a tile), vocab/kanji flashcards (+ example sentences), shadowing lines, and grammar examples
- [x] `LessonRecorder` service consolidates XP / streak / modules-done / badge evaluation in one place
- [x] `reviewDueCountProvider` aggregates due cards across hiragana + katakana + vocab + kanji

### Theme & shell
- [x] Persimmon `#E8763E` accent, Plus Jakarta Sans
- [x] `AppColors` tokens, Material 3 theme with no card borders, no AppBar elevation
- [x] Bottom nav: Home / Learn / Dictionary / You with animated tab switch + haptics

### Home dashboard
- [x] Greeting (`DAY N` + `おかえり。`)
- [x] Hero stats — XP / streak / modules done (typographic, hairline-divided)
- [x] Streak flame breathing
- [x] Today's plan card driven by `AdaptiveDailyPlan` — label flips between `On track` / `Catching up` / `Ahead of plan`
- [x] Week strip — 7 dots, today larger + ringed (resets at day boundary)
- [x] Goal card — JLPT target, stage indicator, stage path dots, day progress bar
- [x] Review card — totals across kana / vocab / kanji via `reviewDueCountProvider`, hidden when 0
- [x] Daily Start CTA picks the next module based on the learner's starting point
- [x] Review CTA opens the unified `ReviewHubScreen`

### Learn tab
- [x] Core modules: Hiragana / Katakana / Kanji / Vocabulary — all unlocked, each shows the live seed count
- [x] Practice modules: Reading / Shadowing / JLPT mock test
- [x] Hairline-separated rows, spring-squish on tap

### Kana modules (hiragana + katakana)
- [x] Browse all characters in a grid (tap to hear), status tints per character (NEW / LEARN / DUE / OK)
- [x] Flashcard mode with reveal + Again/Know-it
- [x] Quiz mode alternating kana → romaji and romaji → kana
- [x] **Recall** mode — show the kana, type the romaji; auto-graded (accepts common spellings, e.g. shi/si, wo/o), feeds the same SRS
- [x] Per-character SRS via `kana_progress`
- [x] Single `KanaModuleScreen(type:)` parameterized for both scripts (4 tabs)

### Vocabulary module
- [x] Browse list with per-card SRS status
- [x] Flashcard mode shows reading + example sentence on reveal, with a JP→EN / EN→JP toggle (recall the word from its meaning, not just recognise it)
- [x] Multi-choice quiz (front → meaning)
- [x] Per-card SRS via `card_progress(deck: vocab)`

### Kanji module
- [x] Browse list with on/kun + strokes/level — tap a row to open the kanji detail
- [x] Radicals tab groups kanji by component (each radical shows its plain-English meaning); tap any kanji to open its detail
- [x] Kanji detail screen — big character + audio, meaning, on/kun, strokes/level, component breakdown (what each part means), and real example words that use the kanji (each with audio)
- [x] Flashcard mode with JP→EN / EN→JP recall toggle
- [x] Multi-choice quiz (kanji → meaning)
- [x] Per-card SRS via `card_progress(deck: kanji)`

### Dictionary
- [x] Search across vocabulary AND kanji (word / reading / meaning / on / kun)
- [x] Bookmarks (star toggle) with dedicated `bookmark` table
- [x] Bookmark list visible when search is empty

### Review hub
- [x] Pulls all SRS-due vocab + kanji into one flashcard stream
- [x] "Inbox zero" state when nothing is due

### Practice modules
- [x] Reading — 4 graded passages (N5 / N4), translation toggle, XP reward on completion
- [x] Shadowing — 7 sentence drill with self-rating (rough / OK / smooth) and XP
- [x] JLPT mock test — N5 only, 5-minute timer, explanation per answer, pass/fail summary

### Gamification
- [x] 9 badges in `BadgeCatalog` (first review, hiragana/katakana mastered, streaks 3/7, XP 100/500, vocab/kanji counts)
- [x] Snackbar toast when a badge is unlocked from any module
- [x] Profile screen shows level card (`xp/100`), streak / streak-freezes / day / modules stats, badge grid (locked/unlocked)
- [x] Streak freeze — auto-absorbs one missed day so a single slip doesn't reset the streak; earned every 5-day streak, capped at 2 (lives in `UserProgress`, persisted via `freeze_tokens`)
- [x] Anki import entry point lives under Profile → Tools (parser still TODO)

### Onboarding
- [x] Welcome screen
- [x] Q1 JLPT level / Q2 timeline (3/6/12/custom) / Q3 starting point
- [x] Generated daily kanji / vocab / review minutes plan
- [x] Persisted to `user_goal`
- [x] First-launch gate shows onboarding when no `user_goal` exists

### Adaptive goal tracker
- [x] `UserGoal.adaptiveFor()` scales daily load ±25% / 20% based on calendar-vs-plan delta
- [x] Status label drives the Today card subtitle

### Progress wiring
- [x] Every lesson event routes through `LessonRecorder` → XP, streak (with proper day-skip reset), week mask, today_done reset at midnight, badge evaluation, modules-done re-count
- [x] Home review card driven by the unified due-count provider

### Tests
- [x] `sm2_test.dart` — interval growth, reset, mastery threshold
- [x] `adaptive_plan_test.dart` — on-track / behind / ahead branches
- [x] `user_progress_test.dart` — streak grow, skip-day reset, level-up, freeze earn / absorb-one-day / can't-cover-two-day-gap
- [x] `kana_progress_test.dart` — wraps SM-2 via kana progress
- [x] `widget_test.dart` — boots onboarding, finishes flow, renders home

## Mocked / deferred
- Anki `.apkg` import: entry point lives at Profile → Tools. Parser & file picker behind a TODO (the format is a SQLite-in-zip; needs an extra package).
- Stroke-order animation for kanji: kanji module exposes radical decomposition; animated stroke order is intentionally out of scope (no animation library bundled).
- Cross-device cloud sync: intentionally **cancelled** — `PLAN.md` mandates an offline-first architecture, sync would require a backend.
- Japanese font: still OS fallback. Bundling Zen Kaku Gothic / Noto Sans JP can land any time without code changes (just add asset + declare in `pubspec.yaml`).
- Audio: now on-device TTS (`ja-JP`, slowed rate). Pre-recorded native MP3s per item are still a nicer-quality follow-up but no longer blocking.
- Shadowing record-and-compare: the line now plays via TTS so learners have audio to mimic; recording the learner's voice + A/B playback is deferred (needs a mic-record package + runtime permission, low ROI for an internal app).
- Kanji mnemonics: instead of authoring 100+ prose stories, the detail screen teaches via the radical/component breakdown (each part's meaning) — the WaniKani-style scaffold a mnemonic is built from.

## Open questions (still relevant)
- Higher JLPT levels (N4–N1): onboarding locks them until content exists. Need vocab/kanji/grammar sets per level before unlocking.
- "Modules done" currently counts hiragana + katakana mastery and ≥10 vocab / ≥5 kanji mastered; revisit thresholds once real learners use it.

## File map
```
lib/
├── main.dart
├── theme/app_theme.dart
├── shell/app_shell.dart
├── shared/{placeholder_screen, speak_button}.dart
├── data/
│   ├── providers.dart
│   ├── database/database_helper.dart
│   ├── srs/sm2.dart
│   ├── radical_glossary.dart                 — radical → plain-English meaning
│   ├── services/{lesson_recorder, tts_service}.dart
│   ├── models/{kana, kana_progress, user_goal, user_progress, vocabulary, kanji, card_progress, bookmark, badge}.dart
│   ├── repositories/{kana, kana_progress, user_goal, user_progress, vocabulary, kanji, card_progress, bookmark, badge}_repository.dart
│   └── seed/{kana_seed, vocabulary_seed(+_extra), kanji_seed(+_extra), grammar_seed, reading_seed, quiz_seed}.dart
└── features/
    ├── home/home_screen.dart                — dashboard
    ├── kana/{kana_module_screen, kana_browse_view, kana_flashcard_view, kana_quiz_view, kana_recall_view}.dart
    ├── card_deck/{deck_card, deck_browse_view, deck_flashcard_view, deck_quiz_view}.dart
    ├── vocabulary/vocabulary_screen.dart
    ├── kanji/{kanji_screen, kanji_radicals_view, kanji_detail_screen}.dart
    ├── grammar/grammar_screen.dart
    ├── dictionary/dictionary_screen.dart
    ├── reading/reading_screen.dart
    ├── shadowing/shadowing_screen.dart
    ├── jlpt_mock/jlpt_mock_screen.dart
    ├── review/review_hub_screen.dart
    ├── anki/anki_import_screen.dart
    ├── learn/learn_screen.dart
    ├── profile/profile_screen.dart
    └── onboarding/{onboarding_screen, onboarding_choice_widgets, onboarding_summary_widgets}.dart
```
