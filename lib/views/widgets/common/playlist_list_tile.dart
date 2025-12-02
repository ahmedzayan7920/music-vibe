import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_vibe/views/widgets/common/list_tile_leading.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../logic/playlists_cubit/playlists_cubit.dart';

class PlaylistListTile extends StatelessWidget {
  const PlaylistListTile(
      {super.key, required this.playlist, required this.onTap});
  final PlaylistModel playlist;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        playlist.playlist.toString(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        "${playlist.numOfSongs} songs",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Platform.isAndroid
          ? IconButton(
              onPressed: () {
                _showDeleteDialog(context);
              },
              icon: const Icon(Icons.delete_forever_outlined),
            )
          : null,
      leading: ListTileLeading(
        id: playlist.id,
        type: ArtworkType.PLAYLIST,
        placeholderIcon: Icons.playlist_play_outlined,
      ),
    );
  }

  Future<dynamic> _showDeleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure you want to delete this playlist?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                getIt<PlaylistsCubit>().removePlayList(id: playlist.id);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
