import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/repositories/query_repository.dart';

import 'songs_state.dart';

class SongsCubit extends Cubit<SongsState> {
  final QueryRepository _queryRepository;

  SongsCubit({required QueryRepository queryRepository})
      : _queryRepository = queryRepository,
        super(SongsInitialState());

  queryAllSongs() async {
    print("queryAllSongs Started");
    emit(SongsLoadingState());
    if (_queryRepository.allSongs.isEmpty) {
      _querySongs();
    } else {
      emit(SongsSuccessState(songs: _queryRepository.allSongs));
      print(
          "queryAllSongs Ended with ${_queryRepository.allSongs.length} songs");
    }
  }

  refreshQueryAllSongs() async {
    emit(SongsLoadingState());
    _querySongs();
  }

  _querySongs() async {
    final result = await _queryRepository.queryAllSongs();
    result.fold(
      (failure) {
        print("queryAllSongs Error: $failure");
        emit(SongsFailureState(message: failure.message));
      },
      (songs) {
        print(
            "queryAllSongs Ended with ${_queryRepository.allSongs.length} songs");
        emit(SongsSuccessState(songs: songs));
      },
    );
  }
}
