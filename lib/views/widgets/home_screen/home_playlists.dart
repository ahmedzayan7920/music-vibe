import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/core/di/dependency_injection.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../logic/playlists_cubit/playlists_cubit.dart';
import '../../../logic/playlists_cubit/playlists_state.dart';
import '../../screens/playlist_songs_screen.dart';
import '../common/playlist_list_tile.dart';

class HomePlaylists extends StatelessWidget {
  const HomePlaylists({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<PlaylistsCubit>()..queryAllPlaylists(),
      child: BlocBuilder<PlaylistsCubit, PlaylistsState>(
        buildWhen: (previous, current) =>
            current is PlaylistsLoadingState ||
            current is PlaylistsFailureState ||
            current is PlaylistsSuccessState,
        builder: (context, state) {
          if (state is PlaylistsSuccessState) {
            List<PlaylistModel> allPlaylists = state.allPlaylists;
            if (allPlaylists.isEmpty) {
              return RefreshIndicator(
              onRefresh: () async {
                context.read<PlaylistsCubit>().refreshQueryAllPlaylists();
              },
                child: Center(
                  child: Text(
                    "No Playlists Found",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PlaylistsCubit>().refreshQueryAllPlaylists();
              },
              child: ListView.builder(
                itemCount: allPlaylists.length,
                itemBuilder: (context, index) {
                  print(
                      "************ ${allPlaylists[index].data} ************");
                  return PlaylistListTile(
                    playlist: allPlaylists[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaylistSongsScreen(
                            playlistId: allPlaylists[index].id,
                            playlistName: allPlaylists[index].playlist,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else if (state is PlaylistsFailureState) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
