import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/logic/songs_cubit/songs_cubit.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../logic/songs_cubit/songs_state.dart';
import '../../../repositories/query_repository.dart';
import '../../screens/player_screen.dart';

class HomeSongs extends StatelessWidget {
  const HomeSongs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SongsCubit(queryRepository: getIt<QueryRepository>())..queryAllSongs(),
      child: BlocBuilder<SongsCubit, SongsState>(
        builder: (context, state) {
          if (state is SongsSuccessState) {
            List<SongModel> allSongs = state.songs;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<SongsCubit>().refreshQueryAllSongs();
              },

              child: ListView.builder(
                itemCount: allSongs.length,
                itemBuilder: (context, index) {
                  SongModel song = allSongs[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerScreen(
                            songs: allSongs,
                            index: index,
                          ),
                        ),
                      );
                    },
                    title: Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      song.artist ?? "unknown",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: QueryArtworkWidget(
                          id: song.id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(Icons.music_note),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
