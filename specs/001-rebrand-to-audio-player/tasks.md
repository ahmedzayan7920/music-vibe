# Tasks: Rebrand to SonicVibe (Global Audio Player)

**Input**: Design documents from `/specs/001-rebrand-to-audio-player/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Tests**: Tests are OPTIONAL and are not explicitly requested. Focus on safe refactoring and build verification.

**Organization**: Tasks are grouped by execution phase and user story to ensure a completely safe, testable, and step-by-step branding shift.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Execute native renaming and configure rebranded package variables.

- [x] T001 Execute Android and iOS app user-visible name rename using the `rename` CLI command: `flutter pub run rename setAppName --targets android,ios,macos --value "SonicVibe"`
- [x] T002 Execute Android and iOS native package and bundle identifier rename using the `rename` CLI command: `flutter pub run rename setBundleId --targets android,ios,macos --value "com.digitalTrans.sonicVibe"`
- [x] T003 [P] Update package name under `pubspec.yaml` name attribute from `music_vibe` to `sonic_vibe` at `/Users/zayan/StudioProjects/music-vibe/pubspec.yaml`
- [x] T004 Update all local source files in `lib/` and tests in `test/` to replace imports referencing `package:music_vibe/` with `package:sonic_vibe/`
- [x] T005 [P] Configure launcher icon target image configurations inside `/Users/zayan/StudioProjects/music-vibe/pubspec.yaml` and regenerate icons via `flutter pub run flutter_launcher_icons`
- [x] T006 [P] Configure splash screen color and layout inside `/Users/zayan/StudioProjects/music-vibe/pubspec.yaml` and regenerate native splashes via `flutter pub run flutter_native_splash:create`
- [x] T007 Run `flutter clean` and `flutter pub get` at repository root to clear compilation caches and register the renamed package

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Complete structural renaming of folders and core database/media classes before UI refactoring can begin.

**⚠️ CRITICAL**: No user story UI work can begin until this phase is complete and builds successfully.

- [x] T008 Rename directory `lib/logic/songs_cubit` to `lib/logic/tracks_cubit`
- [x] T009 Rename file `lib/logic/tracks_cubit/songs_cubit.dart` to `lib/logic/tracks_cubit/tracks_cubit.dart`
- [x] T010 Rename file `lib/logic/tracks_cubit/songs_state.dart` to `lib/logic/tracks_cubit/tracks_state.dart`
- [x] T011 Refactor class name `SongsCubit` and `SongsState` inside `lib/logic/tracks_cubit/tracks_cubit.dart` and `tracks_state.dart` to `TracksCubit` and `TracksState`
- [x] T012 Rename file `lib/core/handlers/song_handler.dart` to `lib/core/handlers/track_handler.dart`
- [x] T013 Refactor all references to "songs" and "song" within `lib/core/handlers/track_handler.dart` (except third-party class types like `SongModel`)
- [x] T014 Refactor repository `lib/repositories/query_repository.dart` to rename methods like `queryAllSongs` to `queryAllTracks`, `queryPlaylistSongs` to `queryPlaylistTracks`, and `queryFavoriteSongs` to `queryFavoriteTracks`
- [x] T015 Update dependency injection registrations inside `lib/core/di/dependency_injection.dart` to reference the renamed `TracksCubit` and repository methods
- [x] T016 Rename view file `lib/views/screens/songs_screen.dart` to `lib/views/screens/tracks_screen.dart` and rename `SongsScreen` widget class name to `TracksScreen`

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel.

---

## Phase 3: User Story 1 - Unified App Rebranding (Priority: P1) 🎯 MVP

**Goal**: Deliver the rebranded SonicVibe splash screen, home screen, and visual components removing music/song terms.

**Independent Test**: Build and run the app, verify splash screen shows SonicVibe logo and app title, home screens show tracks instead of songs.

- [x] T017 [US1] Refactor home screen `/Users/zayan/StudioProjects/music-vibe/lib/views/screens/home_screen.dart` to display "Tracks" instead of "Songs" and use rebranded names
- [x] T018 [US1] Rename home widget `lib/views/widgets/home_screen/home_songs.dart` to `lib/views/widgets/home_screen/home_tracks.dart` and rename its internal class
- [x] T019 [P] [US1] Rename list tile widget `lib/views/widgets/common/song_list_tile.dart` to `lib/views/widgets/common/track_list_tile.dart` and rename its class
- [x] T020 [P] [US1] Rename list tile widget `lib/views/widgets/common/song_list_tile_trailing.dart` to `lib/views/widgets/common/track_list_tile_trailing.dart` and rename its class
- [x] T021 [US1] Update all UI screens (Search, Favorites) to replace static labels of "Song" or "Songs" with "Track" or "Tracks"

**Checkpoint**: User Story 1 fully functional. All visible UI has been rebranded.

---

## Phase 4: User Story 2 - Codebase & File Rebranding (Priority: P2)

**Goal**: Complete full codebase-wide refactoring of all folders, attributes, and variables to keep terms generic and aligned.

**Independent Test**: Perform case-insensitive search for `song` and `songs` within all Dart source files and confirm only library imports remain.

- [x] T022 [US2] Refactor all track variables and attributes inside `/Users/zayan/StudioProjects/music-vibe/lib/repositories/query_repository.dart` from `songs` to `tracks`
- [x] T023 [US2] Refactor player screen `/Users/zayan/StudioProjects/music-vibe/lib/views/screens/player_screen.dart` to rename all local variables, widget configurations, and handlers from song to track
- [x] T024 [US2] Refactor play/pause control logic in `/Users/zayan/StudioProjects/music-vibe/lib/views/widgets/player_screen/play_pause_button.dart` to align names from song to track
- [x] T025 [US2] Rename player songs list helper widget `/Users/zayan/StudioProjects/music-vibe/lib/views/widgets/player_screen/player_songs_list.dart` to `player_tracks_list.dart` and rename class
- [x] T026 [US2] Systematic refactoring of albums, artists, folders cubits in `lib/logic/` and screens in `lib/views/screens/` to use renamed track variables

**Checkpoint**: User Stories 1 and 2 complete. The entire Dart codebase is clean and rebranded.

---

## Phase 5: User Story 3 - Visual Brand Assets & Package Update (Priority: P3)

**Goal**: Update native configurations, manifest package names, launcher icons, and store metadata preparing for Google Play.

**Independent Test**: Successfully execute native release build (Gradle) with package com.digitalTrans.sonicVibe and verify splash.

- [x] T027 [US3] Verify Android manifest and build.gradle files inside `android/` directory have bundle ID renamed to `com.digitalTrans.sonicVibe`
- [x] T028 [US3] Verify plist and project configuration files inside `macos/` and `ios/` have bundle ID renamed to `com.digitalTrans.sonicVibe`
- [x] T029 [US3] Confirm native compilation successfully completes and launcher icon launches SonicVibe correctly on the device

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Cleanup, formatting, documentation, and user data migration validation.

- [x] T030 Update main `README.md` at project root replacing all "Music Vibe" branding with "SonicVibe" and generic audio player setup instructions
- [x] T031 Perform thorough manual testing of favorites, playlists, and settings persistence keys ensuring zero data loss
- [x] T032 Clean and format codebase using `flutter format .` and resolve any analyzer warnings

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories.
- **User Stories (Phase 3+)**: All depend on Foundational phase completion.
  - User stories can then proceed in parallel or sequentially in priority order (P1 → P2 → P3).
- **Polish (Final Phase)**: Depends on all desired user stories being complete.

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel (T003, T005, T006).
- User Story 1 tasks marked [P] can run in parallel (T019, T020).

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently (Rebranded UI MVP ready!)
