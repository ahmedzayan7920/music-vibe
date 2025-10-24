import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/repositories/query_repository.dart';

import 'songs_state.dart';

class SongsCubit extends Cubit<SongsState> {
  final QueryRepository _queryRepository;

  SongsCubit({required QueryRepository queryRepository})
      : _queryRepository = queryRepository,
        super(SongsInitialState());

  Future<void> queryAllSongs() async {
    emit(SongsLoadingState());
    if (_queryRepository.allSongs.isEmpty) {
      _querySongs();
    } else {
      emit(SongsSuccessState(allSongs: _queryRepository.allSongs));
    }
  }

  Future<void> refreshQueryAllSongs() async {
    emit(SongsLoadingState());
    _querySongs();
  }

  Future<void> _querySongs() async {
    final result = await _queryRepository.queryAllSongs();
    result.fold(
      (failure) {
        emit(SongsFailureState(message: failure.message));
      },
      (songs) {
        emit(SongsSuccessState(allSongs: songs));
      },
    );
  }
}
