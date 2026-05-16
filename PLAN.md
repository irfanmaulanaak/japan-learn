# Japan Learn — Rencana Aplikasi

## Vision
Aplikasi belajar bahasa Jepang cross-platform (Android, iOS, macOS, Windows, Linux) dengan pendekatan Spaced Repetition System (SRS), gamifikasi, dan goal tracking.

## Tech Stack
- **Framework:** Flutter (Dart) — cross-platform
- **State Management:** BLoC / Riverpod (TBD)
- **Local Database:** SQLite (sqflite / drift)
- **SRS Algorithm:** SM-2 (yang dipake Anki)
- **Local Storage:** Hive / SharedPreferences untuk settings & progress

## Keputusan Arsitektur

### Online vs Offline
- **90% fitur full offline** — data dibundling di APK
- Data yang dibundling: hiragana/katakana, vocab, kanji, radicals, soal kuis, grammar
- Tidak perlu koneksi internet untuk operasional harian
- Content reading (artikel) bisa digenerate sendiri, tidak perlu live API

### Fitur Tidak Termasuk
- ❌ AI tutor / chatbot

## Fitur Lengkap & Roadmap

### Fase 1 — MVP
| Fitur | Keterangan |
|-------|-----------|
| **🈳 Hiragana & Katakana Learning** | Flashcard + quiz menulis, per baris (a,i,u,e,o → ka,ki,ku,ke,ko) |
| **🔄 SRS Flashcards** | Sistem pengulangan spasi SM-2 untuk vocab & kanji |
| **📖 Kamus Offline** | Search kata, contoh kalimat, bookmark |
| **🎯 Timeline Goal Tracker** | Onboarding: target JLPT + timeline → daily plan otomatis |
| **📊 Progress Tracking** | Streak, XP, Level, progress bar per modul |

### Fase 2 — Penguatan
| Fitur | Keterangan |
|-------|-----------|
| **🔤 Kanji by Radicals** | Belajar kanji dari komponen dasar, stroke order animation |
| **🧪 Kuis Interaktif** | Tebak arti, listening quiz, drag & drop, multiple choice |
| **🏆 Gamifikasi** | Achievement badges, streak rewards, level-up system |

### Fase 3 — Mahir
| Fitur | Keterangan |
|-------|-----------|
| **🗣️ Shadowing Practice**| Record suara + play back + bandingkan dengan native |
| **📰 Reading Content**| Artikel graded (N5→N1) yang digenerate sendiri |
| **🏆 JLPT Mock Test** | Simulasi ujian N5 sampai N1, timer, scoring |

### Fase 4 — Polish
| Fitur | Keterangan |
|-------|-----------|
| **Anki Deck Import** | Import deck .apkg dari Anki |
| **Sync Across Devices** | Opsional backup progress via cloud |

## Desain
- **Style:** Minimalis + Gamified
- **Color:** Palet bersih, aksen Jepang
- **Typography:** Noto Sans JP untuk keterbacaan kanji
- **Target User:** Semua level (N5 → N1)

## Goal Tracker — Detail Flow
1. **Onboarding Awal (3 pertanyaan):**
   - Level target? (N5 / N4 / N3 / N2 / N1)
   - Target waktu? (3 bulan / 6 bulan / 1 tahun / custom)
   - Starting point? (NOL TOTAL / bisa hiragana / dsb)
2. **Sistem generate:**
   - Timeline milestone (misal N5 dalam 3 bulan = 5 kanji/hari + 10 vocab/hari)
   - Daily goal otomatis
   - Progress bar visual menuju target

## Struktur Database (Awal)
- `kana` — hiragana & katakana (karakter, romaji, stroke order, audio)
- `vocabulary` — kata + arti + contoh kalimat + level JLPT
- `kanji` — kanji + radicals + readings + meaning + level
- `radicals` — komponen kanji
- `user_progress` — SRS state, review history
- `quiz_questions` — soal kuis per kategori
- `user_goal` — target JLPT, timeline, daily plan
