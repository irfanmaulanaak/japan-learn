## Instructions
- Gunakan bahasa Indonesia atau Inggris campuran dalam diskusi.
- Utamakan simple dan concise. Jangan over-engineering.
- Simpan catatan project di bagian Project Notes di bawah, update jika ada perubahan.
- Sebelum nulis kode, baca PLAN.md untuk referensi keputusan arsitektur.

## Guardrails
- Keep files <~400 LOC; split/refactor as needed
- Simplicity first: handle only important cases; no enterprise over-engineering
- New functionality: small OR absolutely necessary
- NEVER delete files/folders/data unless explicitly approved or part of a plan
- Gunakan `git mv` / `git cp` untuk move/copy files

## Tech Stack
- **Framework:** Flutter (Dart)
- **State Management:** BLoC / Riverpod (TBD — tentukan di fase coding)
- **Local DB:** SQLite via drift/sqflite
- **SRS:** SM-2 algorithm
- **Build:** Android + iOS + macOS + Windows + Linux

## Project Notes
Update this section as the project evolves.

- Platform: Flutter cross-platform (Android darat, iOS, macOS, Windows, Linux nanti)
- Pendekatan: full offline-first, data dibundling di APK. Tidak ada ketergantungan API eksternal.
- Fitur inti: SRS flashcards, hiragana/katakana learning, kamus offline, timeline goal tracker, kanji by radicals, kuis, shadowing, JLPT mock test.
- Fitur TIDAK termasuk: AI chatbot/tutor.
- Goal Tracker: onboarding 3 pertanyaan (target level, timeline, starting point) → daily plan otomatis.
- Data content (vocab, kanji, soal) digenerate sendiri, bukan scrap dari API.
- Desain: minimalis + gamified (XP, streak, level, badges).

## Research & Development
- Web search untuk referensi best practices Flutter/SRS/gamifikasi
- Cari referensi database structure untuk aplikasi belajar bahasa
- Cek package Flutter yang cocok (sqflite, hive, audioplayers, dll)

## Error Handling
- Expected issues: explicit result types (bukan throw/try/catch)
- Unexpected issues: fail LOUD (throw/console.error); jangan silent fallback
