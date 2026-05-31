# Tasks: Disable Playlists Feature

**Input**: Design documents from `/specs/002-disable-playlists/`

**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, quickstart.md

**Tests**: Tests are OPTIONAL - only include if explicitly requested (none requested).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project state validation

- [x] T001 Verify active git branch is `002-disable-playlists` per the plan

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Integrity checks on dependency injection and codebase compilation

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T002 Verify that the `PlaylistsCubit` dependency registration is preserved and compiled without modifications in `lib/core/di/dependency_injection.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Remove Playlists Navigation and Creation (Priority: P1) 🎯 MVP

**Goal**: Completely hide the playlists page, bottom navigation item, and creation triggers from the user dashboard.

**Independent Test**: Build and run the app, verify the "Playlists" navigation tab and the homepage floating action button are completely absent.

### Implementation for User Story 1

- [x] T003 [P] [US1] Remove the `BottomNavigationBarItem` for Playlists (index 1) in `lib/views/widgets/home_screen/home_bottom_navigation_bar.dart`
- [x] T004 [US1] Remove the `HomePlaylists()` widget from the `PageView` children list in `lib/views/screens/home_screen.dart`
- [x] T005 [US1] Set `floatingActionButton` to `null` to disable the creation FAB in `lib/views/screens/home_screen.dart`

**Checkpoint**: User Story 1 is fully functional and testable independently. Playlists tab and creation FAB are hidden.

---

## Phase 4: User Story 2 - Hide Track Association Actions (Priority: P1)

**Goal**: Remove track actions relating to playlists to prevent users from adding songs to non-functional playlists.

**Independent Test**: Open any track list options menu and verify the "Add to Playlist" pop-up action button is completely gone.

### Implementation for User Story 2

- [x] T006 [US2] Remove the track actions `PopupMenuButton` containing the "Add to Playlist" list tile from `lib/views/widgets/common/track_list_tile_trailing.dart` (keep only `AddRemoveFavoriteIcon`)

**Checkpoint**: User Stories 1 and 2 work independently. No playlist modification buttons or track options are available.

---

## Phase 5: User Story 3 - Safe Navigation and Index Handling (Priority: P2)

**Goal**: Ensure swiping transitions and bottom tab highlights map correctly now that playlists are removed.

**Independent Test**: Swipe and navigate through all remaining screens and ensure navigation highlights match active pages.

### Implementation for User Story 3

- [x] T007 [US3] Verify that PageView indexes and navigation tap callbacks map smoothly between the remaining pages without offset crashes or gaps in `lib/views/screens/home_screen.dart` and `lib/views/widgets/home_screen/home_bottom_navigation_bar.dart`

**Checkpoint**: All navigation flows are 100% correct, fluid, and robust.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Verify and finalize the changes

- [x] T008 [P] Run project analyzer with `flutter analyze` to ensure zero compilation or styling warning issues
- [x] T009 Run quickstart.md validation checklist steps to verify all access points are cleanly decoupled

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel
  - Or sequentially in priority order (P1 → P2)
- **Polish (Final Phase)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2)
- **User Story 2 (P2)**: Can start after Foundational (Phase 2)
- **User Story 3 (P3)**: Depends on US1 completion to align the page indexing mapping

---

## Parallel Example: User Story 1

```bash
# Launch changes in different files in parallel:
Task: "Remove Playlists BottomNavigationBarItem in lib/views/widgets/home_screen/home_bottom_navigation_bar.dart"
Task: "Remove HomePlaylists() page widget and FAB in lib/views/screens/home_screen.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 & 2)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1 (Remove main navigation points)
4. Complete Phase 4: User Story 2 (Remove track actions menu button)
5. **STOP and VALIDATE**: Verify UI is clean and playlists are hidden
6. Deploy / merge

### Incremental Delivery

1. Complete Setup + Foundational
2. Add User Story 1 (Hidden tab & FAB)
3. Add User Story 2 (No track popup menu options)
4. Add User Story 3 (Correct navigation highlights & indices)
5. Run Polish verification
