import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/views/widgets/common/track_list_tile.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../logic/favorites_cubit/favorites_cubit.dart';
import '../../../logic/favorites_cubit/favorites_state.dart';
import '../common/empty_state.dart';
import '../common/shuffle_list_tile.dart';

class HomeFavorites extends StatelessWidget {
  const HomeFavorites({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<FavoritesCubit>()..queryFavoriteTracks(),
      child: BlocBuilder<FavoritesCubit, FavoritesState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is FavoritesSuccessState) {
            List<SongModel> allFavoriteTracks = state.allFavoriteTracks;
            if (allFavoriteTracks.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<FavoritesCubit>().queryFavoriteTracks();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      child: EmptyState(message: 'No Favorites Found'),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                allFavoriteTracks.isEmpty
                    ? const SizedBox()
                    : ShuffleListTile(tracks: allFavoriteTracks),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<FavoritesCubit>().queryFavoriteTracks();
                    },
                    child: ListView.builder(
                      itemCount: allFavoriteTracks.length,
                      itemBuilder: (context, index) {
                        return TrackListTile(
                          allTracks: allFavoriteTracks,
                          track: allFavoriteTracks[index],
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
