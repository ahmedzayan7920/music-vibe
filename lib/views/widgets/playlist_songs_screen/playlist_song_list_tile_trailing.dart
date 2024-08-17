import 'package:flutter/material.dart';
import 'package:music_vibe/core/di/dependency_injection.dart';
import 'package:music_vibe/logic/playlists_cubit/playlists_cubit.dart';

import '../common/add_remove_favorite_icon.dart';

class PlaylistSongListTileTrailing extends StatelessWidget {
  const PlaylistSongListTileTrailing({
    super.key,
    required this.playlistId,
    required this.songId,
  });

  final int playlistId;
  final int songId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddRemoveFavoriteIcon(id: songId),
        IconButton(
          onPressed: () {
            getIt<PlaylistsCubit>()
                .removeSongFromPlayList(playlistId: playlistId, songId: songId);
          },
          icon: const Icon(Icons.delete_forever_outlined),
        ),
      ],
    );
  }
}
