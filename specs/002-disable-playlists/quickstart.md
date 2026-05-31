# Quickstart: Verify Decoupled Playlists Feature

## Overview
This quickstart explains how to run the application and verify that all Playlists UI entry points are fully disabled and hidden.

---

## Verification Steps

### Step 1: Running the Application
Launch the application locally in development mode:
```bash
flutter run
```

### Step 2: Bottom Navigation Bar Verification
- Verify that the bottom navigation bar contains only:
  1. **Sounds** (formerly "Sounds" at index 0)
  2. **Albums** (formerly index 2, now at index 1)
  3. **Artists** (formerly index 3, now at index 2)
  4. **Folders** (formerly index 4, now at index 3 - Android only)
  5. **Favorites** (formerly index 5, now index 3/4)
- Confirm that the "Playlists" navigation icon is completely gone.

### Step 3: Horizontal Page Swiping Verification
- Swipe horizontally through all pages from the "Sounds" page.
- Verify that you transition directly into the "Albums" page.
- Confirm there is no index crash or page misalignment during transitions.

### Step 4: Track Trailing Options Menu Verification
- Go to any track list item in "Sounds" or "Albums".
- View the trailing portion of the track.
- Verify that the three-dot popup menu button is no longer visible, leaving only the favorite heart icon.
- Confirm that you cannot trigger or view the "Add to Playlist" pop-up.
