import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/repositories/query_repository.dart';

import 'artists_state.dart';

class ArtistsCubit extends Cubit<ArtistsState> {
  final QueryRepository _queryRepository;

  ArtistsCubit({required QueryRepository queryRepository})
      : _queryRepository = queryRepository,
        super(ArtistsInitialState());

  queryAllArtists() async {
    emit(ArtistsLoadingState());
    if (_queryRepository.allArtists.isEmpty) {
      _queryArtists();
    } else {
      emit(ArtistsSuccessState(allArtists: _queryRepository.allArtists));
    }
  }

  refreshQueryAllArtists() async {
    emit(ArtistsLoadingState());
    _queryArtists();
  }

  _queryArtists() async {
    final result = await _queryRepository.queryAllArtists();
    result.fold(
      (failure) {
        emit(ArtistsFailureState(message: failure.message));
      },
      (artists) {
        emit(ArtistsSuccessState(allArtists: artists));
      },
    );
  }
}
