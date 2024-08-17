import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/repositories/query_repository.dart';

import 'albums_state.dart';

class AlbumsCubit extends Cubit<AlbumsState> {
  final QueryRepository _queryRepository;

  AlbumsCubit({required QueryRepository queryRepository})
      : _queryRepository = queryRepository,
        super(AlbumsInitialState());

  queryAllAlbums() async {
    emit(AlbumsLoadingState());
    if (_queryRepository.allAlbums.isEmpty) {
      _queryAlbums();
    } else {
      emit(AlbumsSuccessState(allAlbums: _queryRepository.allAlbums));
    }
  }

  refreshQueryAllAlbums() async {
    emit(AlbumsLoadingState());
    _queryAlbums();
  }

  _queryAlbums() async {
    final result = await _queryRepository.queryAllAlbums();
    result.fold(
      (failure) {
        emit(AlbumsFailureState(message: failure.message));
      },
      (albums) {
        emit(AlbumsSuccessState(allAlbums: albums));
      },
    );
  }
}
