import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../logic/artists_cubit/artists_cubit.dart';
import '../../../logic/artists_cubit/artists_state.dart';
import '../common/artist_list_tile.dart';
import '../common/empty_state.dart';

class HomeArtists extends StatelessWidget {
  const HomeArtists({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ArtistsCubit>()..queryAllArtists(),
      child: BlocBuilder<ArtistsCubit, ArtistsState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is ArtistsSuccessState) {
            List<ArtistModel> allArtists = state.allArtists;
            if (allArtists.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ArtistsCubit>().refreshQueryAllArtists();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      child: EmptyState(message: 'No Artists Found'),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ArtistsCubit>().refreshQueryAllArtists();
              },
              child: ListView.builder(
                itemCount: allArtists.length,
                itemBuilder: (context, index) {
                  ArtistModel artist = allArtists[index];
                  return ArtistListTile(
                    artist: artist,
                  );
                },
              ),
            );
          } else if (state is ArtistsFailureState) {
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
