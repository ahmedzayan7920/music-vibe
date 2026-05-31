# Research & Decisions: Disable Playlists Feature

## Core Objectives
Research the references and dependencies of the Playlists feature in the codebase to design a safe, non-breaking decoupling strategy that hides all UI access points while preserving compilation stability.

---

## Decisions & Rationales

### Decision 1: Code Decoupling over Deletion
- **Decision**: Retain all playlist-related file assets (`home_playlists.dart`, `playlist_tracks_screen.dart`, `playlists_cubit.dart`, etc.) in the project codebase, but completely unregister or disable all active UI entry points.
- **Rationale**: Retaining files avoids any broken import compiles or missing reference errors. It also ensures that if we choose to fix the playlist files issues and restore the feature in the future, we can do so with minimal code restoration effort.
- **Alternatives Considered**: 
  - *Complete Deletion*: Rejected because it would require recovering code from Git if the feature is ever reintroduced, and poses risks of compilation issues due to leftover references.

### Decision 2: Dependency Registration Preservation
- **Decision**: Keep the `PlaylistsCubit` registered in the `get_it` dependency injection container (`dependency_injection.dart`).
- **Rationale**: Keeps the DI graph fully intact, preventing compile errors where `getIt<PlaylistsCubit>` is initialized or imported. Decoupling the UI guarantees the Cubit's query functions are never invoked at runtime, meaning zero database query execution overhead.
- **Alternatives Considered**:
  - *Full DI Unregistration*: Rejected because other files containing reference imports would need exhaustive refactoring, increasing risk without functional benefits.

### Decision 3: Track Options Trailing Menu Cleanup
- **Decision**: Remove the popup menu button entirely from `TrackListTileTrailing` since "Add to Playlist" is the only option inside it.
- **Rationale**: Cleaning up the whole pop-up button is much cleaner for the UI than having an empty pop-up menu or a non-functional entry. It leaves only the active/working favorite button on each track.
- **Alternatives Considered**:
  - *Disabling only the "Add to Playlist" menu option*: Rejected because it leaves an empty popup menu button which would look unpolished and broken.

---

## Architectural Mapping
The following files are affected and require modifications to achieve decoupling:

1. **`lib/views/screens/home_screen.dart`**:
   - Remove `HomePlaylists()` from `PageView` children.
   - Set `floatingActionButton` to `null` (removing `HomeFloatingActionButton()` conditional trigger at page index 1).
2. **`lib/views/widgets/home_screen/home_bottom_navigation_bar.dart`**:
   - Remove the `BottomNavigationBarItem` for "Playlists".
3. **`lib/views/widgets/common/track_list_tile_trailing.dart`**:
   - Remove `PopupMenuButton` which contains the "Add to Playlist" list tile. Keep only `AddRemoveFavoriteIcon`.
