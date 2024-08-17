import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/logic/playlists_cubit/playlists_cubit.dart';

import '../../core/di/dependency_injection.dart';
import '../../logic/playlists_cubit/playlists_state.dart';
import '../widgets/common/shuffle_list_tile.dart';
import '../widgets/mini_player.dart';
import '../widgets/playlist_songs_screen/playlist_song_list_tile.dart';
import '../widgets/playlist_songs_screen/playlist_songs_floating_action_button.dart';

class PlaylistSongsScreen extends StatelessWidget {
  const PlaylistSongsScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });
  final int playlistId;
  final String playlistName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<PlaylistsCubit>()..queryPlaylistSongs(id: playlistId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(playlistName),
        ),
        body: BlocBuilder<PlaylistsCubit, PlaylistsState>(
          buildWhen: (previous, current) =>
              current is PlaylistSongsLoadingState ||
              current is PlaylistSongsFailureState ||
              current is PlaylistSongsSuccessState,
          builder: (context, state) {
            if (state is PlaylistSongsSuccessState) {
              final allSongs = state.allSongs;
              if (allSongs.isEmpty) {
                return Center(
                  child: Text(
                    "No Songs Found",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              }
              return Column(
                children: [
                  allSongs.isEmpty
                      ? const SizedBox()
                      : ShuffleListTile(songs: allSongs),
                  Expanded(
                    child: ListView.builder(
                      itemCount: allSongs.length,
                      itemBuilder: (context, index) {
                        return PlaylistSongListTile(
                          allSongs: allSongs,
                          song: allSongs[index],
                          playlistId: playlistId,
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is PlaylistSongsFailureState) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        bottomNavigationBar: const MiniPlayer(),
        floatingActionButton:
            PlaylistSongsFloatingActionButton(playlistId: playlistId),
      ),
    );
  }
}
