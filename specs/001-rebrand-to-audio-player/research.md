# Phase 0: Outline & Research - Rebrand to SonicVibe

## Decision: Brand Renaming Strategy
- **App Name Choice**: `SonicVibe` (replaces `Music Vibe`).
- **Android Package Identifier / macOS Bundle ID**: `com.digitalTrans.sonicVibe` (replaces `com.digitalTrans.musicVibe`). Keeps the reverse-domain prefix `com.digitalTrans` ensuring structural continuity while fully shifting the product brand.
- **Flutter Package Name**: `sonic_vibe` (replaces `music_vibe`). All internal source files will update their imports from `package:music_vibe/...` to `package:sonic_vibe/...`.

## Rationale
- **SonicVibe** preserves the vibrant and aesthetic "Vibe" that aligns with the visual design (dark mode, purple neon, Lottie assets), but drops the restrictive word "Music" in favor of "Sonic" (generic sound/audio terminology).
- Rebranding `package:music_vibe` to `package:sonic_vibe` is essential to prevent build errors and keep the codebase clean, self-documenting, and free of obsolete references.
- Keeps third-party libraries (e.g. `on_audio_query_pluse` which returns `SongModel` data types) isolated behind our repository interface mapping, ensuring compile safety.

## Alternatives Considered
- **Audibly**: Rejected because it loses the "Vibe" connection that matches the current aesthetic and assets.
- **Aura Player**: Rejected because `SonicVibe` provides a more direct, energetic bridge to the existing visual animations.
- **UI Strings Only Refactoring**: Rejected because leaving internal code named `music_vibe` and `song` would result in severe developer confusion and mismatch for upcoming features.

## Tooling Analysis
- **App Name and Bundle ID**: We verified the `rename` package (v3.0.2) is already declared in `dev_dependencies` in `pubspec.yaml`. We can execute native renaming safely using:
  ```bash
  flutter pub run rename setAppName --targets android,ios,macos --value "SonicVibe"
  flutter pub run rename setBundleId --targets android,ios,macos --value "com.digitalTrans.sonicVibe"
  ```
- **Splash Screen Update**: `flutter_native_splash` is utilized. We will configure and regenerate the splash screen with:
  ```bash
  flutter pub run flutter_native_splash:create
  ```
- **Launcher Icons Update**: `flutter_launcher_icons` is utilized. We will regenerate the app icons with:
  ```bash
  flutter pub run flutter_launcher_icons
  ```
