import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../repositories/query_repository.dart';
import 'playlists_state.dart';

class PlaylistsCubit extends Cubit<PlaylistsState> {
  final QueryRepository _queryRepository;
  final OnAudioQuery _onAudioQuery;

  PlaylistsCubit({
    required QueryRepository queryRepository,
    required OnAudioQuery onAudioQuery,
  })  : _queryRepository = queryRepository,
        _onAudioQuery = onAudioQuery,
        super(PlaylistsInitialState());

  queryAllPlaylists() async {
    emit(PlaylistsLoadingState());
    if (_queryRepository.allPlaylists.isEmpty) {
      _queryPlaylists();
    } else {
      emit(PlaylistsSuccessState(allPlaylists: _queryRepository.allPlaylists));
    }
  }

  refreshQueryAllPlaylists() async {
    emit(PlaylistsLoadingState());
    _queryPlaylists();
  }

  queryPlaylistSongs({required int id}) async {
    emit(PlaylistSongsLoadingState());
    final result = await _queryRepository.queryPlaylistSongs(id: id);
    result.fold(
      (failure) {
        emit(PlaylistSongsFailureState(message: failure.message));
      },
      (songs) {
        emit(PlaylistSongsSuccessState(allSongs: songs));
      },
    );
  }

  addPlayList({required String name}) async {
    emit(PlaylistsLoadingState());
    final success = await _onAudioQuery.createPlaylist(name);
    if (success) {
      await _queryPlaylists();
    } else {
      emit(PlaylistsSuccessState(allPlaylists: _queryRepository.allPlaylists));
    }
  }

  removePlayList({required int id}) async {
    emit(PlaylistsLoadingState());
    final success = await _onAudioQuery.removePlaylist(id);
    if (success) {
      await _queryPlaylists();
    } else {
      emit(PlaylistsSuccessState(allPlaylists: _queryRepository.allPlaylists));
    }
  }

  addSongToPlayList({required int playlistId, required int songId}) async {
    final success = await _onAudioQuery.addToPlaylist(playlistId, songId);
    if (success) {
      queryPlaylistSongs(id: playlistId);
      _queryPlaylists();
    }
  }

  removeSongFromPlayList({required int playlistId, required int songId}) async {
    final success = await _onAudioQuery.removeFromPlaylist(playlistId, songId);
    if (success) {
      queryPlaylistSongs(id: playlistId);
      _queryPlaylists();
    }
  }

  _queryPlaylists() async {
    final result = await _queryRepository.queryAllPlaylists();
    result.fold(
      (failure) {
        emit(PlaylistsFailureState(message: failure.message));
      },
      (playlists) {
        emit(PlaylistsSuccessState(allPlaylists: playlists));
      },
    );
  }
}
