import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/logic/playlists_cubit/playlists_cubit.dart';

import '../../core/di/dependency_injection.dart';
import '../../logic/playlists_cubit/playlists_state.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/shuffle_list_tile.dart';
import '../widgets/mini_player.dart';
import '../widgets/playlist_tracks_screen/playlist_track_list_tile.dart';
import '../widgets/playlist_tracks_screen/playlist_tracks_floating_action_button.dart';

class PlaylistTracksScreen extends StatelessWidget {
  const PlaylistTracksScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });
  final int playlistId;
  final String playlistName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<PlaylistsCubit>()..queryPlaylistTracks(id: playlistId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(playlistName),
        ),
        body: BlocBuilder<PlaylistsCubit, PlaylistsState>(
           buildWhen: (previous, current) =>
              current is PlaylistTracksLoadingState ||
              current is PlaylistTracksFailureState ||
              current is PlaylistTracksSuccessState,
          builder: (context, state) {
            if (state is PlaylistTracksSuccessState) {
              final allTracks = state.allTracks;
              if (allTracks.isEmpty) {
                return const EmptyState(message: 'No Tracks Found');
              }
              return Column(
                children: [
                  allTracks.isEmpty
                      ? const SizedBox()
                      : ShuffleListTile(tracks: allTracks),
                  Expanded(
                    child: ListView.builder(
                      itemCount: allTracks.length,
                      itemBuilder: (context, index) {
                        return PlaylistTrackListTile(
                          allTracks: allTracks,
                          track: allTracks[index],
                          playlistId: playlistId,
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is PlaylistTracksFailureState) {
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
        bottomNavigationBar: SafeArea(child: const MiniPlayer()),
        floatingActionButton:
            PlaylistTracksFloatingActionButton(playlistId: playlistId),
      ),
    );
  }
}
