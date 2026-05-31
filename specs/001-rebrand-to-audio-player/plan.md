# Implementation Plan: Rebrand to SonicVibe (Global Audio Player)

**Branch**: `001-rebrand-to-audio-player` | **Date**: 2026-05-31 | **Spec**: [spec.md](file:///Users/zayan/StudioProjects/music-vibe/specs/001-rebrand-to-audio-player/spec.md)

**Input**: Feature specification from `/specs/001-rebrand-to-audio-player/spec.md`

## Summary
Rebrand the application from "Music Vibe" to a premium global audio player called **SonicVibe**. Remove all references to "music" and "song" in both user-facing strings and internal codebase structures (file names, class names, folders, variables, and methods) using generic terms like "audio" and "track." Renaming native package identifiers, launcher icons, splash screen, and Gradle configurations to completely isolate the old brand, ensuring the application compiles, runs flawlessly, and is ready for Google Play Store publishing.

## Technical Context

**Language/Version**: Dart ^3.5.0, Flutter SDK

**Primary Dependencies**: `flutter_bloc` (v9.1.0), `get_it` (v8.0.3), `just_audio` (v0.10.5), `audio_service` (v0.18.15), `dartz` (v0.10.1), `on_audio_query_pluse` (v3.0.5), `shared_preferences` (v2.3.2)

**Storage**: `shared_preferences` (for saving user preferences and favorites), system media database scanned via `on_audio_query`

**Testing**: `flutter_test` (unit and widget tests)

**Target Platform**: Android & macOS (iOS)

**Project Type**: Mobile Application

**Performance Goals**: Seamless, glitch-free, 60fps UI rendering; background audio controller startup in <100ms.

**Constraints**: Zero compile-time or runtime reference corruption. Precise mapping of external `on_audio_query` types (which contain fixed library names) to clean, generic internal models.

**Scale/Scope**: Refactoring all UI strings, configuration files, and ~100% of internal Dart source files across `lib/core`, `lib/logic`, `lib/repositories`, and `lib/views`.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Direct Alignment & Implementation |
|---|---|---|
| **I. Feature-First & Clean Architecture** | ✅ Passed | Separation between `lib/core`, `lib/logic`, `lib/repositories`, and `lib/views` will be maintained and systematically renamed (e.g. `songs` features to `tracks`). |
| **II. Cubit-First & Equatable States** | ✅ Passed | State management cubits (e.g., `TracksCubit`, `PlaylistsCubit`) will manage state with `Equatable` states. |
| **III. Strict UI & Widget Standards** | ✅ Passed | Refactored widgets will continue to exist strictly as class declarations with const constructors and named parameters. |
| **IV. Type-Safe Error Handling & Robust Data Layer** | ✅ Passed | Renamed repository methods and data layers will continue returning `Either<Failure, Success>` from dartz. |
| **V. Centralized Styling, Theming & Localization** | ✅ Passed | Central color assets, easy_localization assets (`en.json`, `ar.json`), and `AppStrings` will be updated to remove music-specific terms. |

## Project Structure

### Documentation (this feature)

```text
specs/001-rebrand-to-audio-player/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── checklists/
│   └── requirements.md  # Specification Quality Checklist
└── tasks.md             # Phase 2 output (/speckit-tasks command)
```

### Source Code Layout (Refactored)

The existing architecture is organized around standard global folders rather than a strict feature-first system. We will preserve this structure while executing safe generic renames:

```text
lib/
├── core/
│   ├── di/
│   │   └── dependency_injection.dart  # Updates: register renamed Cubits/repos
│   ├── failure/
│   ├── handlers/
│   │   └── track_handler.dart         # Renamed from song_handler.dart
│   └── theming/
│       └── app_themes.dart
├── logic/
│   ├── albums_cubit/
│   ├── artists_cubit/
│   ├── favorites_cubit/
│   ├── folders_cubit/
│   ├── playlists_cubit/
│   └── tracks_cubit/                  # Renamed from songs_cubit/
├── repositories/
│   └── query_repository.dart          # Renamed internal methods (e.g., queryAllTracks)
└── views/
    ├── albums_view.dart
    ├── favorites_view.dart
    ├── playlists_view.dart
    ├── tracks_view.dart               # Renamed from songs_view.dart
    └── widgets/                       # Reusable sub-widgets
```

**Structure Decision**: Global layered architecture. All Dart folders and filenames associated with `song` and `songs` will be systematically renamed to `track` and `tracks`.

## Complexity Tracking

*No current violations of the project constitution or key developer constraints.*

---
