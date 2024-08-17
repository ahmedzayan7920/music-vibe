import 'package:flutter/material.dart';
import 'package:music_vibe/core/di/dependency_injection.dart';
import 'package:music_vibe/logic/playlists_cubit/playlists_cubit.dart';
import 'package:music_vibe/repositories/query_repository.dart';
import 'package:music_vibe/views/widgets/common/playlist_list_tile.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'add_remove_favorite_icon.dart';

class SongListTileTrailing extends StatelessWidget {
  const SongListTileTrailing({
    super.key,
    required this.songId,
  });

  final int songId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddRemoveFavoriteIcon(id: songId),
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(
                    Icons.playlist_add_outlined,
                  ),
                  title: const Text("Add to Playlist"),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final allPlaylists =
                            getIt<QueryRepository>().allPlaylists;
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.grey[200] ?? Colors.grey,
                              width: .5,
                            ),
                          ),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * .5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: allPlaylists.isEmpty
                                  ? const Center(
                                      child: Text("No Playlists Found"))
                                  : Column(
                                      children: [
                                        const Text(
                                          "Playlists",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: allPlaylists.length,
                                            itemBuilder: (context, index) {
                                              return PlaylistListTile(
                                                playlist: allPlaylists[index],
                                                onTap: () {
                                                  isSongExist(
                                                          playlistId:
                                                              allPlaylists[
                                                                      index]
                                                                  .id)
                                                      .then(
                                                    (isExist) {
                                                      if (isExist) {
                                                        if (context.mounted) {
                                                          ScaffoldMessenger.of(
                                                              context)
                                                            ..hideCurrentSnackBar()
                                                            ..showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    "Song already Exists"),
                                                              ),
                                                            );
                                                        }
                                                      } else {
                                                        getIt<PlaylistsCubit>()
                                                            .addSongToPlayList(
                                                          playlistId:
                                                              allPlaylists[
                                                                      index]
                                                                  .id,
                                                          songId: songId,
                                                        );
                                                        if (context.mounted) {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      }
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  Future<bool> isSongExist({
    required int playlistId,
  }) async {
    List<SongModel> playlistSongs = [];
    final result =
        await getIt<QueryRepository>().queryPlaylistSongs(id: playlistId);
    result.fold(
      (l) {
        playlistSongs =
            getIt<QueryRepository>().allPlaylistsSongs[songId] ?? [];
      },
      (r) {
        playlistSongs = r;
      },
    );

    List<SongModel> match =
        playlistSongs.where((element) => element.id == songId).toList();
    return match.isNotEmpty;
  }
}
