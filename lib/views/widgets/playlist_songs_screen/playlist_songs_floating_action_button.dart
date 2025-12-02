import 'package:flutter/material.dart';
import 'package:music_vibe/logic/playlists_cubit/playlists_cubit.dart';
import 'package:music_vibe/repositories/query_repository.dart';
import 'package:music_vibe/views/widgets/common/list_tile_leading.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

import '../../../core/di/dependency_injection.dart';
import '../common/empty_state.dart';

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
                  child: allSongs.isEmpty
                      ? const EmptyState(message: 'No Sounds Found')
                      : Column(
                          children: [
                            const Text(
                              "Sounds",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: allSongs.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      allSongs[index].title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    leading: ListTileLeading(
                                      id: allSongs[index].id,
                                      type: ArtworkType.AUDIO,
                                      placeholderIcon:
                                          Icons.music_note_outlined,
                                    ),
                                    onTap: () {
                                      if (getIt<QueryRepository>()
                                              .allPlaylistsSongs[playlistId]
                                              ?.contains(allSongs[index]) ??
                                          false) {
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text("Sound already Exists"),
                                            ),
                                          );
                                      } else {
                                        Navigator.pop(context);
                                        getIt<PlaylistsCubit>()
                                            .addSongToPlayList(
                                          playlistId: playlistId,
                                          songId: allSongs[index].id,
                                        );
                                      }
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
      child: const Icon(Icons.add),
    );
  }
}
