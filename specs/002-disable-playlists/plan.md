# Implementation Plan: Disable Playlists Feature

**Branch**: `002-disable-playlists` | **Date**: 2026-05-31 | **Spec**: [spec.md](file:///Users/zayan/StudioProjects/music-vibe/specs/002-disable-playlists/spec.md)

**Input**: Feature specification from `/specs/002-disable-playlists/spec.md`

## Summary
De-couple and hide all Playlists UI entry points (Bottom Navigation item, Homepage PageView index, Track list trailing PopupMenu options, and Homepage Floating Action Button) to disable the broken playlists experience. This prevents users from interacting with external/broken playlist files, while retaining all existing logic files (`PlaylistsCubit`, `PlaylistTracksScreen`, etc.) to prevent compilation errors and ensure a simple path for future fixes/restoration.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x

**Primary Dependencies**: `flutter_bloc`, `get_it`, `auto_route`, `easy_localization`, `equatable`, `on_audio_query_pluse`

**Storage**: None (external playlist files queried via `on_audio_query_pluse` will be ignored/not loaded at runtime)

**Testing**: `flutter test` for widget and routing validation

**Target Platform**: iOS / Android / macOS

**Project Type**: mobile-app

**Performance Goals**: Zero playlist database scans or file-system queries on dashboard load, improving initial application responsiveness.

**Constraints**: All other features (Sounds, Albums, Artists, Folders, Favorites) must continue working seamlessly with correct navigation indices.

**Scale/Scope**: Moderate UI adjustment: modify 3 UI widgets/screens, remove 1 conditional FAB, preserve 1 dependency injection registration.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Gate I - Feature-First & Clean Architecture**: **PASSED**. Logical boundary separating presentation and business layers is preserved. Playlists logic code is decoupled but remains in its designated directories.
- **Gate II - Cubit-First & Equatable States**: **PASSED**. No changes to existing Cubit states or structures are introduced.
- **Gate III - Strict UI & Widget Standards**: **PASSED**. Home screens and list widgets remain purely declarative stateless/stateful widget classes. No helper UI building methods are created.
- **Gate IV - Centralized Styling, Theming & Localization**: **PASSED**. No new user-facing strings or localizations are introduced.
- **Gate V - Safe Data Operations**: **PASSED**. No new data sources, databases, or API operations are introduced.

## Project Structure

### Documentation (this feature)

```text
specs/002-disable-playlists/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
└── quickstart.md        # Phase 1 output (/speckit-plan command)
```

### Source Code (repository root)

```text
lib/
├── core/
│   └── di/
│       └── dependency_injection.dart        # PlaylistsCubit registration preserved
├── logic/
│   └── bottom_navigation_cubit/
│       └── bottom_navigation_cubit.dart     # Tracks active page navigation index
├── views/
│   ├── screens/
│   │   └── home_screen.dart                 # HomeScreen PageView children and FAB updated
│   └── widgets/
│       ├── home_screen/
│       │   └── home_bottom_navigation_bar.dart  # "Playlists" navigation item removed
│       └── common/
│           └── track_list_tile_trailing.dart    # "Add to Playlist" PopupMenuButton removed
```

**Structure Decision**: A single-project Flutter application utilizing feature-first structure. All existing files under `lib/logic/playlists_cubit` and `lib/views/screens/playlist_tracks_screen.dart` are kept in the codebase but successfully decoupled from imports in active viewports.

## Complexity Tracking

*No constitution violations or complex architectural overrides exist for this feature.*
