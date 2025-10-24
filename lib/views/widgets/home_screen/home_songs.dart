import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/logic/songs_cubit/songs_cubit.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../logic/songs_cubit/songs_state.dart';
import '../common/empty_state.dart';
import '../common/shuffle_list_tile.dart';
import '../common/song_list_tile.dart';

class HomeSongs extends StatelessWidget {
  const HomeSongs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SongsCubit>()..queryAllSongs(),
      child: BlocBuilder<SongsCubit, SongsState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is SongsSuccessState) {
            List<SongModel> allSongs = state.allSongs;
            if (allSongs.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<SongsCubit>().refreshQueryAllSongs();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      child: EmptyState(message: 'No Sounds Found'),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                allSongs.isEmpty
                    ? const SizedBox()
                    : ShuffleListTile(songs: allSongs),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<SongsCubit>().refreshQueryAllSongs();
                    },
                    child: ListView.builder(
                      itemCount: allSongs.length,
                      itemBuilder: (context, index) {
                        SongModel song = allSongs[index];
                        return SongListTile(allSongs: allSongs, song: song);
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is SongsFailureState) {
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
    );
  }
}
