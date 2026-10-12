# Repository Instructions

## Project
- This is a Flutter app for Quran revision, with saved difficult ayahs, Mushaf reading layouts, quizzes, bookmarks, translations, and mutashabihat.
- The package is `quran_memorization_helper`; the Dart SDK constraint is `>=3.7.0`.
- App code is under `lib/`, organized into `models/`, `pages/`, `quran_data/`, `utils/`, and `widgets/`. Tests are under `test/`; Quran text, translations, and related data are under `assets/`; Mushaf fonts are under `fonts/`.

## Commands
- Install dependencies: `flutter pub get`
- Analyze Dart and Flutter code: `flutter analyze`
- Run the test suite: `flutter test --concurrency=1` (CI uses serial execution.)
- Build the Android APK using the repository script: `bash build.sh` (the script builds split APKs for Android arm64.)
- Build the Windows release: `build_windows.bat` (requires Flutter and Visual Studio 2022 C++ desktop tools.)

## Conventions
- Follow the existing Dart and Flutter patterns in the nearest related file. Keep changes scoped and avoid unrelated formatting or refactoring.
- Follow `analysis_options.yaml`, including `always_declare_return_types` and the included `flutter_lints` rules.
- Prefer the existing model, Quran data, and utility APIs over duplicating domain logic. Add or update focused tests in `test/` for behavior changes.
- Treat Quran text, ayah indices, page layouts, translations, and font/data assets as correctness-sensitive. Preserve source text and ordering; do not normalize or regenerate these assets unless the task requires it.
- Keep persisted settings and ayah/bookmark data compatible with existing JSON formats unless a migration is explicitly part of the change.
