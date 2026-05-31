import 'package:flutter/material.dart';
import 'package:sonic_vibe/core/di/dependency_injection.dart';
import 'package:sonic_vibe/logic/playlists_cubit/playlists_cubit.dart';
import 'package:sonic_vibe/repositories/query_repository.dart';
import 'package:sonic_vibe/views/widgets/common/playlist_list_tile.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

import 'add_remove_favorite_icon.dart';
import 'empty_state.dart';

class TrackListTileTrailing extends StatelessWidget {
  const TrackListTileTrailing({
    super.key,
    required this.trackId,
  });

  final int trackId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddRemoveFavoriteIcon(id: trackId),
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
                                      child: EmptyState(
                                          message: 'No Playlists Found'))
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
                                                  isTrackExist(
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
                                                                    "Sound already Exists"),
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
                                                          songId: trackId,
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

  Future<bool> isTrackExist({
    required int playlistId,
  }) async {
    List<SongModel> playlistTracks = [];
    final result =
        await getIt<QueryRepository>().queryPlaylistTracks(id: playlistId);
    result.fold(
      (l) {
        playlistTracks =
            getIt<QueryRepository>().allPlaylistsTracks[trackId] ?? [];
      },
      (r) {
        playlistTracks = r;
      },
    );

    List<SongModel> match =
        playlistTracks.where((element) => element.id == trackId).toList();
    return match.isNotEmpty;
  }
}
