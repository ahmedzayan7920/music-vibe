import 'package:get_it/get_it.dart';
import 'package:music_vibe/core/handlers/song_handler.dart';
import 'package:music_vibe/logic/albums_cubit/albums_cubit.dart';
import 'package:music_vibe/logic/playlists_cubit/playlists_cubit.dart';
import 'package:music_vibe/logic/songs_cubit/songs_cubit.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../logic/artists_cubit/artists_cubit.dart';
import '../../repositories/query_repository.dart';

var getIt = GetIt.instance;

initDependencyInjection() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerSingleton<MyAudioHandler>(await initAudioService());
  getIt.registerLazySingleton<OnAudioQuery>(() => OnAudioQuery());
  getIt.registerLazySingleton<QueryRepository>(
    () => QueryRepository(audioQuery: getIt<OnAudioQuery>())
      ..queryAllSongs()
      ..queryAllPlaylists()
      ..queryAllAlbums()
      ..queryAllArtists(),
  );
  getIt.registerLazySingleton<SongsCubit>(
    () => SongsCubit(
      queryRepository: getIt<QueryRepository>(),
    ),
  );
  getIt.registerLazySingleton<PlaylistsCubit>(
    () => PlaylistsCubit(
      queryRepository: getIt<QueryRepository>(),
      onAudioQuery: getIt<OnAudioQuery>(),
    ),
  );
  getIt.registerLazySingleton<AlbumsCubit>(
    () => AlbumsCubit(
      queryRepository: getIt<QueryRepository>(),
    ),
  );
  getIt.registerLazySingleton<ArtistsCubit>(
    () => ArtistsCubit(
      queryRepository: getIt<QueryRepository>(),
    ),
  );
}
