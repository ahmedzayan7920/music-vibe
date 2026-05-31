# Feature Specification: Rebrand to Audio Player

**Feature Branch**: `001-rebrand-to-audio-player`

**Created**: 2026-05-31

**Status**: Draft

**Input**: User description: "i want to rebrand the app with different name, and i want also to make it not have music name or word but make it like a global audio player and not music. i think of make this for strings that shows in the ui and also in the file names, attributes, methods and everything. so what do you think and what we can do and name it?"

## Clarifications

### Session 2026-05-31
- Q: What should be the new premium name of the app? → A: **SonicVibe**
- Q: How deeply should we refactor the internal codebase names? → A: **Option A (Full Refactoring of UI & Codebase, with a zero-corruption guarantee through precise reference tracking)**
- Q: Do we want to rename the native package identifier and bundle names? → A: **Option A (Yes, full native package name update e.g. to com.sonicvibe or similar, ensuring it is ready for Google Play publishing)**

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Unified App Rebranding (Priority: P1)

As a user, when I open the application, I want to see the new premium, non-music-focused brand name, logo, and messaging across all screens and UI elements so that I experience the app as a comprehensive, high-quality audio player rather than just a music player.

**Why this priority**: Crucial first step of the rebranding effort, establishing the new identity for the user.

**Independent Test**: Verify all visible user-interface text, titles, dialogue boxes, settings, and menus display the new brand name and remove all references to "music" or "song" (replacing them with "audio" or "track").

**Acceptance Scenarios**:

1. **Given** the user launches the application, **When** they view the splash screen or home screen, **Then** they see the new brand name **SonicVibe** and logo instead of "Music Vibe".
2. **Given** the user navigates through any screen (e.g., Playing Now, Playlists, Tracks, Albums), **When** they read text elements, **Then** they see generalized audio terms (e.g. "Tracks", "Audio files") instead of "Songs" or "Music".

---

### User Story 2 - Codebase & File Rebranding (Priority: P2)

As a developer, I want all source files, directories, methods, attributes, and variables to be refactored to remove "music" and "song" terminology and use generic audio terminology, so that the codebase is perfectly aligned with the new product identity.

**Why this priority**: Essential to avoid technical debt, naming mismatch, and confusion for developers working on the rebranded project.

**Independent Test**: Run codebase search for case-insensitive `music` or `song` within all Dart files, and verify that only references in third-party library imports (like `on_audio_query`) remain, while all local code is renamed.

**Acceptance Scenarios**:

1. **Given** a developer is examining the directory structure, **When** they inspect the features and core files, **Then** files like `song_handler.dart` and cubits like `songs_cubit.dart` are renamed to track/audio terms.
2. **Given** a developer is reading method and variable names, **When** they check audio model attributes, **Then** all local attributes use track or audio terms (e.g., `trackName` instead of `songName`).

---

### User Story 3 - Visual Brand Assets & Package Update (Priority: P3)

As a product owner, I want the application package name, launcher icons, and localized metadata in app stores to be updated to match the new brand, so that the brand transition is completely seamless from downloading to playing.

**Why this priority**: Ensures a consistent external presence on the operating system and app stores.

**Independent Test**: Verify the launcher icon, package identifier (in `AndroidManifest.xml`, `Info.plist`, `pubspec.yaml`), and localization configurations are updated and successfully compile/run.

**Acceptance Scenarios**:

1. **Given** the app is installed on a device, **When** the user looks at the home screen, **Then** they see the new launcher icon and the new app label.
2. **Given** the app is built for Android/iOS, **When** the package identity is checked, **Then** it does not contain `music_vibe` or `music` terms.

---

### Edge Cases

- **Third-Party Dependency Limitations**: The app uses `on_audio_query_pluse` which has fixed models like `SongModel`. Local repository mappings must map these external models to our new clean internal representations.
- **Migration of Simple & Database Storage**: Local storage databases (Hive) or preferences containing keys with old terms (e.g., favorite songs list stored under key `favorite_songs`) must be migrated gracefully without losing user data or causing database crashes.
- **Android/iOS Package Renaming**: Changes to package identifier (e.g., `com.example.music_vibe`) might affect build paths, deep links, or platform channel configurations.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The application MUST display the new brand name **SonicVibe** in the launcher, window title, splash screen, and all UI headings.
- **FR-002**: All user-facing hardcoded text strings in UI screens and widgets MUST be scanned and refactored to replace "music" and "song" references with generic audio and track terminology.
- **FR-003**: The codebase MUST be refactored fully (including all filenames, directories, attributes, classes, and methods, keeping third-party imports intact) with absolute compile-time and run-time safety to replace "music" and "song" with generic terms.
- **FR-004**: The project package identity (renamed to com.sonicvibe or similar brand-focused ID) and launcher icons MUST be updated fully across Android (Gradle, Manifest) and iOS/macOS (plist, bundle id) to completely isolate the old brand for Google Play publishing.
- **FR-005**: A database/storage migration layer MUST be implemented to map legacy Hive DB and SharedPreferences keys to the new generic naming scheme without losing user data.

### Key Entities

- **Track (formerly Song)**: Represents a single playable audio file. Attributes: `id`, `title`, `artist`, `album`, `uri`, `duration`, `size`.
- **AudioPlayer (formerly MusicPlayer)**: The core service managing background and foreground audio playback, media buttons, and audio state.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of user-facing UI elements show the new brand name and generic audio terminology instead of music-specific terms.
- **SC-002**: 100% of the local codebase files, variables, methods, and classes are refactored to align with the new brand nomenclature (subject to scope choice).
- **SC-003**: Existing users upgrading the app preserve 100% of their favorites, playlists, and settings through a seamless database/keys migration.
- **SC-004**: The application builds and runs successfully on Android and macOS/iOS with the new package identifier and launcher icons.

## Assumptions

- **A-001**: The external library `on_audio_query_pluse` will remain as the core query engine, but its output models will be mapped instantly to our new internal types.
- **A-002**: The central color scheme and overall premium dark/purple layout of the app will be retained, simply updated with the new brand name and logos.
- **A-003**: The user wants to carry out this transition in a clean, systematic manner.
