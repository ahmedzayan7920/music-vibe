import 'package:get_it/get_it.dart';
import 'package:music_vibe/core/handlers/track_handler.dart';
import 'package:music_vibe/logic/collections_cubit/collections_cubit.dart';
import 'package:music_vibe/logic/favorites_cubit/favorites_cubit.dart';
import 'package:music_vibe/logic/creators_cubit/creators_cubit.dart';
import 'package:music_vibe/logic/tracks_cubit/tracks_cubit.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../logic/folders_cubit/folders_cubit.dart';
import '../../logic/playlists_cubit/playlists_cubit.dart';
import '../../repositories/query_repository.dart';

var getIt = GetIt.instance;

Future<void> initDependencyInjection() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerSingleton<MyAudioHandler>(await initAudioService());
  getIt.registerLazySingleton<OnAudioQuery>(() => OnAudioQuery());
  getIt.registerLazySingleton<QueryRepository>(
    () => QueryRepository(
      audioQuery: getIt<OnAudioQuery>(),
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );
  getIt.registerLazySingleton<TracksCubit>(
    () => TracksCubit(
      queryRepository: getIt<QueryRepository>(),
    ),
  );
  getIt.registerLazySingleton<PlaylistsCubit>(
    () => PlaylistsCubit(
      queryRepository: getIt<QueryRepository>(),
      onAudioQuery: getIt<OnAudioQuery>(),
    ),
  );
  getIt.registerLazySingleton<CollectionsCubit>(
    () => CollectionsCubit(
      queryRepository: getIt<QueryRepository>(),
    ),
  );
  getIt.registerLazySingleton<CreatorsCubit>(
    () => CreatorsCubit(
      queryRepository: getIt<QueryRepository>(),
    ),
  );
  getIt.registerLazySingleton<FavoritesCubit>(
    () => FavoritesCubit(
      queryRepository: getIt<QueryRepository>(),
    ),
  );
  getIt.registerLazySingleton<FoldersCubit>(
    () => FoldersCubit(
      queryRepository: getIt<QueryRepository>(),
    ),
  );
}
