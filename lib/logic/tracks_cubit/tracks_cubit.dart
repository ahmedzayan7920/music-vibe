import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_vibe/repositories/query_repository.dart';

import 'tracks_state.dart';

class TracksCubit extends Cubit<TracksState> {
  final QueryRepository _queryRepository;

  TracksCubit({required QueryRepository queryRepository})
      : _queryRepository = queryRepository,
        super(TracksInitialState());

  Future<void> queryAllTracks() async {
    emit(TracksLoadingState());
    if (_queryRepository.allTracks.isEmpty) {
      _queryTracks();
    } else {
      emit(TracksSuccessState(allTracks: _queryRepository.allTracks));
    }
  }

  Future<void> refreshQueryAllTracks() async {
    emit(TracksLoadingState());
    _queryTracks();
  }

  Future<void> _queryTracks() async {
    final result = await _queryRepository.queryAllTracks();
    result.fold(
      (failure) {
        emit(TracksFailureState(message: failure.message));
      },
      (tracks) {
        emit(TracksSuccessState(allTracks: tracks));
      },
    );
  }
}
