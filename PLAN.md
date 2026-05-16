# Japan Learn — Application Plan

## Vision
A cross-platform Japanese language learning app (Android, iOS, macOS, Windows, Linux) using Spaced Repetition System (SRS), gamification, and goal tracking.

## Tech Stack
- **Framework:** Flutter (Dart) — cross-platform
- **State Management:** Riverpod
- **Local Database:** SQLite (sqflite / drift)
- **SRS Algorithm:** SM-2 (used by Anki)
- **Local Storage:** Hive / SharedPreferences for settings & progress
- **CI/CD:** GitHub Actions — auto-build APK on push (see `.github/workflows/build-apk.yml`)

## Architecture Decisions

### Online vs Offline
- **90% features fully offline** — data bundled in APK
- Bundled data: hiragana/katakana, vocabulary, kanji, radicals, quiz questions, grammar
- No internet connection required for daily operation
- Reading content (articles) will be self-generated, no live API

### Excluded Features
- ❌ AI chatbot / tutor

## Full Feature List & Roadmap

### Phase 1 — MVP
| Feature | Description |
|---------|-------------|
| **🈳 Hiragana & Katakana Learning** | Flashcards + writing quiz, per row (a,i,u,e,o → ka,ki,ku,ke,ko) |
| **🔄 SRS Flashcards** | SM-2 spaced repetition for vocab & kanji |
| **📖 Offline Dictionary** | Word search, example sentences, bookmarks |
| **🎯 Timeline Goal Tracker** | Onboarding: target JLPT + timeline → auto daily plan |
| **📊 Progress Tracking** | Streak, XP, Level, module progress bars |

### Phase 2 — Reinforcement
| Feature | Description |
|---------|-------------|
| **🔤 Kanji by Radicals** | Learn kanji from component parts, stroke order animation |
| **🧪 Interactive Quizzes** | Guess meaning, listening quiz, drag & drop, multiple choice |
| **🏆 Gamification** | Achievement badges, streak rewards, level-up system |

### Phase 3 — Advanced
| Feature | Description |
|---------|-------------|
| **🗣️ Shadowing Practice** | Record voice + playback + compare with native audio |
| **📰 Reading Content** | Graded articles (N5→N1) self-generated |
| **🏆 JLPT Mock Test** | Timed exam simulation N5–N1, scoring, pass/fail |

### Phase 4 — Polish
| Feature | Description |
|---------|-------------|
| **Anki Deck Import** | Import .apkg decks from Anki |
| **Cross-device Sync** | Optional cloud progress backup |

## Design
- **Style:** Minimal + Gamified
- **Color:** Clean palette with Japanese accent tones
- **Typography:** Noto Sans JP for kanji readability
- **Target User:** All levels (N5 → N1)

## Goal Tracker — Detailed Flow
1. **Initial Onboarding (3 questions):**
   - Target level? (N5 / N4 / N3 / N2 / N1)
   - Target timeline? (3 months / 6 months / 1 year / custom)
   - Starting point? (ABSOLUTE BEGINNER / know hiragana / some kanji / etc.)
2. **System generates:**
   - Timeline milestones (e.g. N5 in 3 months = 5 kanji/day + 10 vocab/day)
   - Auto daily goals
   - Visual progress bar toward target
   - Adaptive: if user falls behind, adjust daily load

## Initial Database Structure
- `kana` — hiragana & katakana (character, romaji, stroke order, audio)
- `vocabulary` — word + translation + example sentences + JLPT level
- `kanji` — kanji + radicals + readings + meaning + JLPT level
- `radicals` — kanji components
- `user_progress` — SRS state, review history
- `quiz_questions` — quiz questions per category
- `user_goal` — JLPT target, timeline, daily plan
