import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/views/widgets/common/song_list_tile.dart';
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
      value: getIt<FavoritesCubit>()..queryFavorites(),
      child: BlocBuilder<FavoritesCubit, FavoritesState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is FavoritesSuccessState) {
            List<SongModel> allFavoriteSongs = state.allFavoriteSongs;
            if (allFavoriteSongs.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<FavoritesCubit>().queryFavorites();
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
                allFavoriteSongs.isEmpty
                    ? const SizedBox()
                    : ShuffleListTile(songs: allFavoriteSongs),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<FavoritesCubit>().queryFavorites();
                    },
                    child: ListView.builder(
                      itemCount: allFavoriteSongs.length,
                      itemBuilder: (context, index) {
                        return SongListTile(
                          allSongs: allFavoriteSongs,
                          song: allFavoriteSongs[index],
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
