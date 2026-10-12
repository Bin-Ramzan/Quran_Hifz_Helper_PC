# Quran Revision Companion

<a href="https://play.google.com/store/apps/details?id=com.wqar.quran_mem_helper">
  <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" height="60" alt="Get it on Google Play">
</a>

<a href="https://f-droid.org/en/packages/com.wqar.quran_mem_helper">
  <img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png" height="60" alt="Get it on F-Droid">
</a>

An app that serves as a companion for Quran revision. The intended user of the app is a Hafiz. Currently it has the following features:
- Create a list of ayahs for each para/juz. These can be ayahs that you find difficult
- 16 Line Mushaf (IndoPak font)
- 15 Line Mushaf (Uthmani font)
- 15 Line Mushaf (IndoPak font)
- 13 Line Mushaf (IndoPak font)
- Take quiz
- View mutashabihat (similar ayat) for each para/juz.
- View translation for each ayat

## Windows

### Download

For the simplest install, open **Releases**, download `Quran-Revision-Companion-Setup-<version>.exe`, and run it. This is a single setup download; it installs the app and creates a Start menu shortcut. You do not need to find or copy files from the Flutter build output.

The **portable ZIP** is for users who prefer not to install. It contains the complete app folder and runtime files. Extract the ZIP, then run `quranmemhelp.exe` from the extracted folder without moving it away from the other files.

The installer is currently unsigned, so Windows SmartScreen may show a warning before allowing it to run.

### Build from source

Install Git, the stable Flutter SDK, and Visual Studio 2022 with the **Desktop development with C++** workload. Then run:

```powershell
git clone https://github.com/Bin-Ramzan/Quran_Hifz_Helper_PC.git
cd Quran_Hifz_Helper_PC
build_windows.bat
```

The build output, including `quranmemhelp.exe` and its required runtime files, is created in `build\windows\x64\runner\Release\`. Run the executable from that folder; a Flutter Windows app cannot run by copying out only the `.exe`.

To publish a downloadable Windows release, push a tag matching the app version in `pubspec.yaml` (for example, `v1.8.3`). GitHub Actions builds the installer and portable ZIP and attaches both to a GitHub Release.

## Mobile development

To run the app from source on a configured Flutter device, use:

```sh
flutter pub get
flutter run
```

## License

- MIT
