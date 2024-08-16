import 'package:flutter/material.dart';
import 'package:music_vibe/logic/cubit/playlists_cubit.dart';
import 'package:music_vibe/repositories/query_repository.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../core/di/dependency_injection.dart';

class PlaylistSongsFloatingActionButton extends StatelessWidget {
  const PlaylistSongsFloatingActionButton({
    super.key,
    required this.playlistId,
  });

  final int playlistId;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            final allSongs = getIt<QueryRepository>().allSongs;
            return Dialog(
              child: SizedBox(
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ListView.builder(
                    itemCount: allSongs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          allSongs[index].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: QueryArtworkWidget(
                              quality: 100,
                              controller: getIt(),
                              id: allSongs[index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const Icon(Icons.music_note),
                            ),
                          ),
                        ),
                        onTap: () {
                          if (getIt<QueryRepository>().allPlaylistsSongs[playlistId]
                              ?.contains(allSongs[index])??false) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text("Song already Exists"),
                                ),
                              );
                          } else {
                            Navigator.pop(context);
                            getIt<PlaylistsCubit>().addSongToPlayList(
                              playlistId: playlistId,
                              songId: allSongs[index].id,
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
