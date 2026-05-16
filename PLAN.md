# Japan Learn — Application Plan

## Vision
A cross-platform Japanese language learning app (Android, iOS, macOS, Windows, Linux) using Spaced Repetition System (SRS), gamification, and goal tracking.

## Tech Stack
- **Framework:** Flutter (Dart) — cross-platform
- **State Management:** Riverpod (`flutter_riverpod`)
- **Local Database:** SQLite (`sqflite`)
- **Local Storage:** `shared_preferences` for settings & lightweight progress
- **SRS Algorithm:** SM-2 (used by Anki)
- **Animation:** `flutter_animate` — spring physics, fades, scale
- **Typography:** `google_fonts` (Plus Jakarta Sans display + body)
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

### Direction
**Playful but refined.** Reference points: Notion, Reflect, modern Duolingo. Quiet surfaces, confident typography, motion only on real interactions. Not a cluttered dashboard, not a kawaii sticker book.

### Palette
Single accent. No multi-color UI. Soft tints reserved for module categorization.

| Token | Hex | Use |
|---|---|---|
| `bg` | `#FBFAF7` | App background (warm neutral) |
| `surface` | `#FFFFFF` | Card surfaces |
| `ink` | `#2A2520` | Primary text |
| `inkSoft` | `#6B645C` | Secondary text |
| `inkMuted` | `#A39B92` | Labels, hints |
| `accent` | `#E8763E` | Persimmon (柿色) — the only brand color |
| `accentDark` | `#C45A28` | Pressed/CTA text on light |
| `accentTint` | `#FBE8DC` | Soft persimmon background |
| `tintSky` / `tintSage` / `tintLavender` | — | Module category tints only |
| `success` | `#3F8D5B` | Correct, completed |
| `danger` | `#D9533F` | Wrong, errors |
| `hairline` | `#EFECE6` | Dividers, locked states |

### Typography
- **Display + body:** Plus Jakarta Sans (via `google_fonts`)
- **Japanese:** OS-native fallback for now; will add Zen Kaku Gothic or Noto Sans JP when kana/kanji UI lands
- Weights: 600 / 700 / 800 — never lighter, never bolder
- Negative letter-spacing on display sizes (`-0.3` to `-1.2`)

### Layout principles
- **No card borders.** Hierarchy via spacing, soft shadow, or tinted background — pick one, never combine.
- **Inline typographic stats**, not chip grids. Hairline dividers when separation is needed.
- **Module rows**, not module cards. Hairline between rows.
- **Generous whitespace** between sections (28–36px).
- **Radius:** 14–22px on surfaces, 999 on pills.
- **AppBar:** left-aligned, no elevation, no surfaceTint.

### Motion (Duolingo-style, restrained)
- Spring squish on every tappable surface
- Counter slide-up + bounce when XP changes
- Streak flame breathes (slow repeat scale)
- Section fade + slide-up on entry (staggered)
- Progress bars ease in from 0 on first paint
- Tab switch: fade + 2% slide
- Real interactions only — no "demo" motion

### Home dashboard sections (top → bottom)
1. Greeting — `DAY N` label + `おかえり。` display
2. Hero stats — XP / streak / modules done, typographic, hairline-divided
3. Today's plan — persimmon-filled card, dynamic `Start`/`Continue` CTA (depends on progress)
4. This week — 7 dots, today is larger and ringed
5. Goal — JLPT target, stage-of-N indicator, stage path dots, progress bar
6. Review — SRS due cards CTA (hidden when 0 due)
7. Recent — last 3 activities with XP earned

### Learn tab
Module list. Hairline-separated rows. Locked rows are hairline-tinted with a lock icon.

### Target user
All levels (N5 → N1). Onboarding routes beginners and intermediates to different starting modules.

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
