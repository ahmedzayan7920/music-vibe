import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../logic/collections_cubit/collections_cubit.dart';
import '../../../logic/collections_cubit/collections_state.dart';
import '../common/album_list_tile.dart';
import '../common/empty_state.dart';

class HomeCollections extends StatelessWidget {
  const HomeCollections({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CollectionsCubit>()..queryAllCollections(),
      child: BlocBuilder<CollectionsCubit, CollectionsState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is CollectionsSuccessState) {
            List<AlbumModel> allCollections = state.allCollections;
            if (allCollections.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<CollectionsCubit>().refreshQueryAllCollections();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      child: EmptyState(message: 'No Collections Found'),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CollectionsCubit>().refreshQueryAllCollections();
              },
              child: ListView.builder(
                itemCount: allCollections.length,
                itemBuilder: (context, index) {
                  AlbumModel album = allCollections[index];
                  return AlbumListTile(
                    album: album,
                  );
                },
              ),
            );
          } else if (state is CollectionsFailureState) {
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
