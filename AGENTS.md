# OpenUsage

## Instructions
- CRITICAL: Use simple, concise language. Avoid overtechnical jargon.
- Be radically precise. No fluff. Pure information only (drop grammar; min tokens).
- Critical: DO NOT OVER-ENGINEER! This app is typically used by 2-5 people, internally only.

## Guardrails
- Use `trash` for deletes
- Use `mv` / `cp` to move and copy files
- Bugs: add regression test when it fits
- Keep files <~400 LOC; split/refactor as needed
- Simplicity first: handle only important cases; no enterprise over-engineering/fallbacks
- New functionality: small OR absolutely necessary
- NEVER delete files, folders or other data unless explicilty approved or part of a plan
- Before writing code, stricly follow the below research rules

## Research
- Prefer skills if available over research.
- Prefer researched knowledge over existing knowledge when skills are unavailable.
- Research: Exa to websearch early, and Ref to seek specific documention or web fetch.
- Best results: Quote exact errors; prefer 2025-2026+ sources.
- Web search for Flutter/SRS/gamification best practices
- Reference database structures for language learning apps
- Evaluate suitable Flutter packages (sqflite, hive, audioplayers, etc.)

## Error Handling
- Expected issues: explicit result types (not throw/try/catch).
- Unexpected issues: fail LOUD (throw/console.error + toast.error); NEVER add silent fallbacks.

## Project Memories
Use below list for durable project notes. Keep each item concise and remove stale notes when the project changes.

- Shell commands should use `rtk` to keep command output token-efficient.
- Explore code with Serena MCP first when available; use targeted shell reads/searches for files Serena cannot access.

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