# Phase 1: Design & Data Model - Rebrand to SonicVibe

Because the application queries files directly from the device operating system using the third-party plugin `on_audio_query_pluse` (which outputs fixed `SongModel`, `PlaylistModel`, `AlbumModel`, and `ArtistModel` types), we will preserve these raw models inside repository query implementations to prevent breaking compiler contracts. However, all our internal business logic layer (Cubits), UI views, custom handler classes, and variables will be mapped to a clean, generic nomenclature.

## Class & Structure Renaming Map

| Original Component | New Component | Details / Responsibility |
|---|---|---|
| `SongsScreen` | `TracksScreen` | View presenting local audio files. |
| `SongsCubit` | `TracksCubit` | Business logic for handling audio files list. |
| `SongsState` | `TracksState` | State model for tracks list. |
| `SongListTile` | `TrackListTile` | Widget representing individual audio tracks in list. |
| `PlaylistSongsScreen` | `PlaylistTracksScreen` | View presenting tracks within a specific playlist. |
| `song_handler.dart` | `track_handler.dart` | Handles native background playing state logic. |
| `MyAudioHandler` | `MyAudioHandler` | Main service class (retains name as it is already generic). |

## Repository Method Renaming Map

Within `QueryRepository`, we map internal lists and queries to use generic audio terminology:

| Legacy Method / Attribute | Refactored Method / Attribute | Responsibility |
|---|---|---|
| `_allSongs` | `_allTracks` | Private cached list of all retrieved audio tracks. |
| `allSongs` | `allTracks` | Public getter for all tracks. |
| `queryAllSongs()` | `queryAllTracks()` | Scans OS media storage for all audio tracks. |
| `queryPlaylistSongs()` | `queryPlaylistTracks()` | Retrieves tracks associated with a specific playlist. |
| `queryFavoriteSongs()` | `queryFavoriteTracks()` | Filters and returns the user's favorited tracks. |
| `queryFolderSongs()` | `queryFolderTracks()` | Scans a specific folder directory for tracks. |

## Storage Key Persistence Mapping

We analyzed the `SharedPreferences` implementation to guarantee 100% safety and zero data corruption for existing users:
- **Favorites List**: Stored under the key `"favorite"` (e.g. `getStringList("favorite")`). This key is completely generic, meaning **no migration is required** and users will preserve their favorited tracks seamlessly.
- **Audio State Key**: Stored under keys like `"audio_source"`, `"audio_position"`, `"current_index"`, `"shuffle"`, and `"loop"`. All of these keys are already generic and will be preserved perfectly, guaranteeing zero disruption to playback history.
