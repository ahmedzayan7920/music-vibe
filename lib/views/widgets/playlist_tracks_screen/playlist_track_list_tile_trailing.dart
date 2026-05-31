import 'package:flutter/material.dart';
import 'package:sonic_vibe/core/di/dependency_injection.dart';
import 'package:sonic_vibe/logic/playlists_cubit/playlists_cubit.dart';

import '../common/add_remove_favorite_icon.dart';

class PlaylistTrackListTileTrailing extends StatelessWidget {
  const PlaylistTrackListTileTrailing({
    super.key,
    required this.playlistId,
    required this.trackId,
  });

  final int playlistId;
  final int trackId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddRemoveFavoriteIcon(id: trackId),
        IconButton(
          onPressed: () {
            getIt<PlaylistsCubit>().removeSongFromPlayList(
                playlistId: playlistId, songId: trackId);
          },
          icon: const Icon(Icons.delete_forever_outlined),
        ),
      ],
    );
  }
}
