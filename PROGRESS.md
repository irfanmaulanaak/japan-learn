# Progress

Track of what's built, what's mocked, what's next. Read `PLAN.md` for the spec; this file is the current state.

## Status
**Phase 1 — MVP** · dashboard, onboarding, and progress state scaffolded. No real learning flows yet.

## Done

### Foundation
- [x] Flutter project initialized (Android + iOS + macOS + Linux + Windows + web targets)
- [x] Riverpod + sqflite + shared_preferences wired
- [x] GitHub Actions APK build workflow
- [x] Android org renamed to `dev.irfanmaulanaak`

### Data layer
- [x] SQLite database helper (`lib/data/database/database_helper.dart`)
- [x] Kana model + repository (`lib/data/models/kana.dart`, `lib/data/repositories/kana_repository.dart`)
- [x] Hiragana seed — 46 characters loaded on first launch (`lib/data/seed/kana_seed.dart`)
- [x] Kana SRS progress table + repository (`lib/data/models/kana_progress.dart`, `lib/data/repositories/kana_progress_repository.dart`)
- [x] Riverpod providers for kana lists (`lib/data/providers.dart`)
- [x] User goal table + repository (`lib/data/models/user_goal.dart`, `lib/data/repositories/user_goal_repository.dart`)
- [x] User progress table + repository (`lib/data/models/user_progress.dart`, `lib/data/repositories/user_progress_repository.dart`)
- [x] Riverpod provider for first-launch goal gate
- [x] Riverpod provider for current progress state

### Theme
- [x] Design language: "playful but refined" (Notion / Reflect / refined-Duolingo)
- [x] Persimmon `#E8763E` as the single brand accent
- [x] Plus Jakarta Sans via `google_fonts`
- [x] `AppColors` tokens (`lib/theme/app_theme.dart`)
- [x] Material 3 theme with no card borders, no AppBar elevation

### App shell
- [x] Bottom nav: Home / Learn / Dictionary / You (`lib/shell/app_shell.dart`)
- [x] Animated tab switch (fade + 2% slide)
- [x] Tab icons spring-scale on selection
- [x] Haptic feedback on tab change

### Home dashboard
- [x] Greeting — `DAY N` + `おかえり。`
- [x] Hero stats row — XP / streak / modules done (typographic, hairline dividers)
- [x] Streak flame breathing animation
- [x] Today's plan card — persimmon hero, dynamic `Start`/`Continue` CTA
- [x] This week strip — 7 dots, today larger + ringed
- [x] Goal card — JLPT target, stage indicator, stage path dots, day progress bar
- [x] Review card — SRS due CTA (hidden when 0)
- [x] Staggered section entry animations
- [x] Reads saved `user_goal` for target, timeline, stage, and daily plan
- [x] Reads saved `user_progress` for XP, streak, modules, day, today progress, week strip, and review count

### Learn tab (UI complete, data mocked)
- [x] Module list — Hiragana / Katakana / Kanji / Vocabulary
- [x] Hiragana shows real seed count from DB
- [x] Hiragana row opens the real module
- [x] Locked state with lock icon
- [x] Hairline row separators

### Motion vocabulary validated
- [x] Spring squish on taps
- [x] Counter rollup (slide + bounce)
- [x] Confetti + celebration overlay (kept for later use)
- [x] Haptic feedback patterns

### Onboarding
- [x] Welcome screen
- [x] Q1 target JLPT level (N5 / N4 / N3 / N2 / N1)
- [x] Q2 timeline (3 months / 6 months / 1 year / custom months)
- [x] Q3 starting point
- [x] Generated daily kanji / vocab / review plan from answers
- [x] Persisted goal to `user_goal`
- [x] First-launch gate shows onboarding when no `user_goal` row exists

### Hiragana module
- [x] Browse all 46 hiragana in a grid
- [x] Flashcard study mode (kana → romaji)
- [x] Quiz mode alternating kana → romaji and romaji → kana
- [x] Per-character SRS state tracking
- [x] Today's lesson routes to Hiragana
- [x] Correct/wrong answers update XP and today progress

## Mocked / placeholder
These still need real learning flows or content behind them.

- Progress values now persist, but stay at initial defaults until lessons update them
- Learn tab module lock/progress state is still mostly static beyond opening Hiragana
- Recent activity is hidden until real lesson activity exists

## Next up

### 1. Katakana module
- Seed katakana data
- Reuse the Hiragana module pattern for browse / flashcard / quiz
- Track per-character SRS state

### Later (per PLAN.md)
- Kanji by radicals
- Vocabulary
- Offline dictionary
- Shadowing
- JLPT mock test

## Open questions
- Japanese font: ship Zen Kaku Gothic / Noto Sans JP as bundled asset, or stay on OS fallback until kanji UI lands?
- Audio: ship MP3s per kana in APK, or generate on-device via TTS?
- "Modules done" — does a module count as done at 100% mastery, or just touched?

## File map
```
lib/
├── main.dart                        — app entry, wires theme + shell
├── theme/app_theme.dart             — AppColors + ThemeData
├── shell/app_shell.dart             — bottom nav + animated switcher
├── shared/placeholder_screen.dart   — coming-soon placeholder
├── data/
│   ├── providers.dart               — Riverpod providers
│   ├── database/database_helper.dart
│   ├── models/kana.dart
│   ├── models/kana_progress.dart
│   ├── models/user_goal.dart
│   ├── models/user_progress.dart
│   ├── repositories/kana_progress_repository.dart
│   ├── repositories/kana_repository.dart
│   ├── repositories/user_goal_repository.dart
│   ├── repositories/user_progress_repository.dart
│   └── seed/kana_seed.dart
└── features/
    ├── home/home_screen.dart        — dashboard (greeting / stats / today / week / goal / review / recent)
    ├── kana/                        — Hiragana browse / flashcard / quiz
    ├── learn/learn_screen.dart      — module list
    ├── dictionary/dictionary_screen.dart  — placeholder
    └── profile/profile_screen.dart  — placeholder
```
