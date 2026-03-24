import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../logic/creators_cubit/creators_cubit.dart';
import '../../../logic/creators_cubit/creators_state.dart';
import '../common/artist_list_tile.dart';
import '../common/empty_state.dart';

class HomeCreators extends StatelessWidget {
  const HomeCreators({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CreatorsCubit>()..queryAllCreators(),
      child: BlocBuilder<CreatorsCubit, CreatorsState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is CreatorsSuccessState) {
            List<ArtistModel> allCreators = state.allCreators;
            if (allCreators.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<CreatorsCubit>().refreshQueryAllCreators();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      child: EmptyState(message: 'No Creators Found'),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CreatorsCubit>().refreshQueryAllCreators();
              },
              child: ListView.builder(
                itemCount: allCreators.length,
                itemBuilder: (context, index) {
                  ArtistModel artist = allCreators[index];
                  return ArtistListTile(
                    artist: artist,
                  );
                },
              ),
            );
          } else if (state is CreatorsFailureState) {
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
