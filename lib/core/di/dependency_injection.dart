import 'package:get_it/get_it.dart';
import 'package:music_vibe/core/handlers/song_handler.dart';
import 'package:music_vibe/logic/cubit/playlists_cubit.dart';
import 'package:music_vibe/logic/songs_cubit/songs_cubit.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        ..queryAllPlaylists());
  getIt.registerFactory<SongsCubit>(
    () => SongsCubit(
      queryRepository: getIt<QueryRepository>(),
    ),
  );
  getIt.registerFactory<PlaylistsCubit>(
    () => PlaylistsCubit(
      queryRepository: getIt<QueryRepository>(),
      onAudioQuery: getIt<OnAudioQuery>(),
    ),
  );
}
