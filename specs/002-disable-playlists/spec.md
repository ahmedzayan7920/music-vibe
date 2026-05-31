# Feature Specification: Disable Playlists Feature

**Feature Branch**: `002-disable-playlists`

**Created**: 2026-05-31

**Status**: Draft

**Input**: User description: "i need to disable the playlists feature because it not working well because if playlist file created from other place, it shows here and i can't add to it or delete it or anything and i tried to fix it but not work so did you think that we should disable it?"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Remove Playlists Navigation and Creation (Priority: P1)

As a user, I want the Playlists feature to be completely hidden from the user interface (including navigation items and creation buttons) so that I do not interact with a non-functional feature and can enjoy a clutter-free, working application experience.

**Why this priority**: The primary goal of this request is to disable the broken Playlists feature. Removing the primary entry points prevents users from accessing or attempting to create playlists.

**Independent Test**: The user launches the application, views the main dashboard navigation, and verifies that the Playlists tab is completely gone. They also verify that no floating action button or creation trigger for playlists is displayed in any active tab.

**Acceptance Scenarios**:

1. **Given** the app has launched, **When** the user looks at the bottom navigation bar, **Then** only "Sounds", "Albums", "Artists", "Folders" (if Android), and "Favorites" are visible, and "Playlists" is completely absent.
2. **Given** the user is viewing the tracks ("Sounds"), albums, or artists lists, **When** they look at the screen layout, **Then** no playlist creation button or floating action button is present.

---

### User Story 2 - Hide Track Association Actions (Priority: P1)

As a user, I want all playlist-related actions on individual audio tracks (such as adding a track to a playlist) to be hidden from track options menus so that I am not presented with options that do not work.

**Why this priority**: Preventing users from attempting to modify playlist assignments for tracks is critical to maintaining a polished, working interface.

**Independent Test**: The user opens the options menu for a track in the sounds, albums, or favorites view, and verifies that the "Add to Playlist" option is not present.

**Acceptance Scenarios**:

1. **Given** the user is on the track list, **When** the user taps the options/popup menu button on any track, **Then** the "Add to Playlist" action is not shown in the options menu.
2. **Given** the "Add to Playlist" action was previously the only item in a track's trailing popup menu, **When** viewing the track tile, **Then** the entire popup menu button is hidden, showing only the favorite icon.

---

### User Story 3 - Safe Navigation and Index Handling (Priority: P2)

As a user, I want the application pages to transition smoothly and map correctly to the updated navigation items without crashes or index conflicts when the Playlists page is skipped.

**Why this priority**: Ensures the removal of a navigation item does not introduce app crashes, wrong page mappings, or broken horizontal swiping index offsets.

**Independent Test**: The user swipes horizontally between pages and taps the bottom navigation icons to verify that page selection maps exactly to the selected icon and does not cause a crash or display the wrong tab.

**Acceptance Scenarios**:

1. **Given** the bottom navigation items are updated, **When** the user taps "Albums" (now at index 1), **Then** the PageView correctly shifts to the Albums screen.
2. **Given** the user swipes horizontally across all screens, **When** swiping from Sounds, **Then** the screen directly transitions to Albums without encountering an empty or broken Playlists page.

---

### Edge Cases

- **System-level Playlist Files**: What happens when external playlist files (.m3u, etc.) exist on the device? The application MUST ignore these files and make no attempt to query or display them since the feature is disabled.
- **Deep Links or Routing Targets**: If the app was previously launched into a playlist screen via deep link or state persistence, the system MUST gracefully fallback to the default screen (Sounds tab) instead of crashing.
- **Empty States**: If a screen has no tracks or playlists, it should display the standard empty state screen without any action buttons directing the user to playlists.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST remove the "Playlists" navigation tab and icon from the bottom navigation bar.
- **FR-002**: The system MUST remove the `HomePlaylists()` view page from the main `PageView` widget.
- **FR-003**: The system MUST remove the Floating Action Button from the homepage that allowed creating playlists.
- **FR-004**: The system MUST remove the "Add to Playlist" option from all track trailing options/popup menus.
- **FR-005**: The system MUST disable or unregister the playlist tracks screen route from the routing/navigation configuration.
- **FR-006**: The system MUST cleanly decouple and disable all UI entry points (such as the bottom navigation tab, playlist creation buttons, and track list options) while preserving the underlying playlist views, cubits, and state files in the codebase for potential future fixing and debugging.
- **FR-007**: The system MUST keep the PlaylistsCubit registered within the dependency injection container (get_it) but completely decoupled from the UI, minimizing compilation break risks and ensuring a smooth potential restoration in the future.

### Key Entities *(include if feature involves data)*

*No entities are introduced or modified; the Playlist entity is being decommissioned or decoupled.*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Zero user-facing options, menus, or navigation items relating to playlists are visible anywhere in the application.
- **SC-002**: 100% of horizontal swiping and bottom navigation tab selections map correctly to their respective screens (Sounds, Albums, Artists, Folders, Favorites) without indexing errors or crashes.
- **SC-003**: Navigating through all screens of the app requires zero playlist-related file scans or database queries, improving initial dashboard load responsiveness.

## Assumptions

- **A-001**: Disabling this feature is a temporary or semi-permanent measure until the playlist handling logic with external files is completely overhauled in a separate spec.
- **A-002**: The other core features (Sounds, Albums, Artists, Folders, Favorites) are completely independent and their functionality is unaffected by disabling playlists.
- **A-003**: External playlist files on the user's device are left untouched and are not deleted or altered by the app.
