# japan_learn （あ）

Offline-first Japanese learning app built with Flutter. SRS flashcards, hiragana/katakana,
kanji by radicals, offline dictionary, JLPT mock test, goal tracker, and gamification
(XP, streaks, streak freezes, badges). All content is bundled — no internet needed after install.

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.7+ — check with `flutter --version`
- First time only (fetch dependencies):

```bash
flutter pub get
```

- Android installs also need `adb` on your PATH (ships with Android SDK platform-tools).

## Install — one line per platform

Run these from the **project root**. Each builds a release binary and installs/launches it.

### Android (device connected via USB or wireless `adb`)

```bash
flutter build apk --release && adb install -r build/app/outputs/flutter-apk/app-release.apk
```

Or build, install, and launch in one step:

```bash
flutter run --release
```

### iOS (macOS + Xcode signing required)

```bash
flutter run --release -d $(flutter devices --machine | python3 -c "import sys,json;print(next(d['id'] for d in json.load(sys.stdin) if d['targetPlatform'].startswith('ios')))")
```

### macOS

```bash
flutter build macos --release && open build/macos/Build/Products/Release/*.app
```

### Windows (PowerShell)

```powershell
flutter build windows --release; .\build\windows\x64\runner\Release\japan_learn.exe
```

### Linux

```bash
flutter build linux --release && ./build/linux/x64/release/bundle/japan_learn
```

### Web (build + serve locally, then open http://localhost:8000)

```bash
flutter build web --release && (cd build/web && python3 -m http.server 8000)
```

## Develop

```bash
flutter run            # debug build with hot reload
flutter test           # run the full test suite
flutter analyze        # static analysis
dart run flutter_launcher_icons   # regenerate app icons from assets/icon/app_icon.png
```
