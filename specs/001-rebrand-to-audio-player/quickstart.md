# Phase 1: Design & Quickstart - Rebrand to SonicVibe

Follow these quick commands to build, configure, and compile the rebranded **SonicVibe** application.

## Native App Rebranding & Native Renaming
We leverage the preconfigured `rename` dev dependency to update all target platform files (Gradle, Kotlin files, Manifests, Info.plist, project configurations) cleanly:

### 1. Rename Application User-Visible Name:
```bash
flutter pub run rename setAppName --targets android,ios,macos --value "SonicVibe"
```

### 2. Rename Native Package Bundle Identifier:
```bash
flutter pub run rename setBundleId --targets android,ios,macos --value "com.digitalTrans.sonicVibe"
```

---

## Brand Assets Regeneration

### 1. Re-Generate App Launcher Icons:
Configure `pubspec.yaml` with the new launcher icon path (`assets/icons/logo.png`), then execute:
```bash
flutter pub run flutter_launcher_icons
```

### 2. Re-Generate Native Splash Screen:
Generate native splash views utilizing the `flutter_native_splash` configuration:
```bash
flutter pub run flutter_native_splash:create
```

---

## Dart Codebase Refactoring Flow
1. Rename all physical files from `song` to `track` across the `lib/` directory structure.
2. Update all class references, variables, and methods (e.g. `SongsCubit` ➔ `TracksCubit`, `allSongs` ➔ `allTracks`).
3. Update package imports from `package:music_vibe/...` to `package:sonic_vibe/...` inside `pubspec.yaml` name attribute and all source files.
4. Execute `flutter clean` and `flutter pub get` to clean compiler caches and re-compile the rebranded package.
