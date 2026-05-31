import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_vibe/logic/tracks_cubit/tracks_cubit.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../logic/tracks_cubit/tracks_state.dart';
import '../common/empty_state.dart';
import '../common/shuffle_list_tile.dart';
import '../common/track_list_tile.dart';

class HomeTracks extends StatelessWidget {
  const HomeTracks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<TracksCubit>()..queryAllTracks(),
      child: BlocBuilder<TracksCubit, TracksState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is TracksSuccessState) {
            List<SongModel> allTracks = state.allTracks;
            if (allTracks.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TracksCubit>().refreshQueryAllTracks();
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
                allTracks.isEmpty
                    ? const SizedBox()
                    : ShuffleListTile(songs: allTracks),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<TracksCubit>().refreshQueryAllTracks();
                    },
                    child: ListView.builder(
                      itemCount: allTracks.length,
                      itemBuilder: (context, index) {
                        SongModel track = allTracks[index];
                        return TrackListTile(
                            allTracks: allTracks, track: track);
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is TracksFailureState) {
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
