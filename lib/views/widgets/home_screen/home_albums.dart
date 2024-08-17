import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../logic/albums_cubit/albums_cubit.dart';
import '../../../logic/albums_cubit/albums_state.dart';
import '../common/album_list_tile.dart';

class HomeAlbums extends StatelessWidget {
  const HomeAlbums({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AlbumsCubit>()..queryAllAlbums(),
      child: BlocBuilder<AlbumsCubit, AlbumsState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is AlbumsSuccessState) {
            List<AlbumModel> allAlbums = state.allAlbums;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AlbumsCubit>().refreshQueryAllAlbums();
              },
              child: ListView.builder(
                itemCount: allAlbums.length,
                itemBuilder: (context, index) {
                  AlbumModel album = allAlbums[index];
                  return AlbumListTile(
                    album: album,
                  );
                },
              ),
            );
          } else if (state is AlbumsFailureState) {
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
