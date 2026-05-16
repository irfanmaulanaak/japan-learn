## Instructions
- Always use English for all documentation and code comments.
- Prefer simple, concise language. No over-engineering.
- Keep project notes updated in the Project Notes section below.
- Read PLAN.md for architecture decisions before writing code.

## Guardrails
- Keep files <~400 LOC; split/refactor as needed
- Simplicity first: handle only important cases; no enterprise over-engineering
- New functionality: small OR absolutely necessary
- NEVER delete files/folders/data unless explicitly approved or part of a plan
- Use `git mv` / `git cp` for move/copy files

## Tech Stack
- **Framework:** Flutter (Dart)
- **State Management:** BLoC / Riverpod (TBD — decide during coding phase)
- **Local DB:** SQLite via drift/sqflite
- **SRS:** SM-2 algorithm
- **Platforms:** Android (primary), iOS, macOS, Windows, Linux

## Project Notes
Update this section as the project evolves.

- Platform: Flutter cross-platform (Android first, then iOS, macOS, Windows, Linux)
- Approach: full offline-first, data bundled in APK. No external API dependency.
- Core features: SRS flashcards, hiragana/katakana learning, offline dictionary, timeline goal tracker, kanji by radicals, quizzes, shadowing, JLPT mock test.
- EXCLUDED features: AI chatbot/tutor.
- Goal Tracker: onboarding 3 questions (target JLPT level, timeline, starting point) → auto-generates daily plan.
- Content data (vocab, kanji, quiz questions) is self-generated, not scraped from APIs.
- Design: minimal + gamified (XP, streak, level, badges).
- CI/CD: GitHub Actions workflow at `.github/workflows/build-apk.yml` — auto-builds APK on push to main/develop.

## Research & Development
- Web search for Flutter/SRS/gamification best practices
- Reference database structures for language learning apps
- Evaluate suitable Flutter packages (sqflite, hive, audioplayers, etc.)

## Error Handling
- Expected issues: explicit result types (not throw/try/catch)
- Unexpected issues: fail LOUD (throw/console.error); no silent fallbacks
