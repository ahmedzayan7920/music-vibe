import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

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

  Future<void> queryAllPlaylists() async {
    emit(PlaylistsLoadingState());
    if (_queryRepository.allPlaylists.isEmpty) {
      _queryPlaylists();
    } else {
      emit(PlaylistsSuccessState(allPlaylists: _queryRepository.allPlaylists));
    }
  }

  Future<void> refreshQueryAllPlaylists() async {
    emit(PlaylistsLoadingState());
    _queryPlaylists();
  }

  Future<void> queryPlaylistTracks({required int id}) async {
    emit(PlaylistTracksLoadingState());
    final result = await _queryRepository.queryPlaylistTracks(id: id);
    result.fold(
      (failure) {
        emit(PlaylistTracksFailureState(message: failure.message));
      },
      (tracks) {
        emit(PlaylistTracksSuccessState(allTracks: tracks));
      },
    );
  }

  Future<void> addPlayList({required String name}) async {
    // Playlist operations are not supported on iOS due to plugin limitations
    if (Platform.isIOS) {
      emit(PlaylistsSuccessState(allPlaylists: _queryRepository.allPlaylists));
      return;
    }
    emit(PlaylistsLoadingState());
    final hasPermission = await _onAudioQuery.permissionsStatus();
    if (!hasPermission) {
      emit(PlaylistsSuccessState(allPlaylists: _queryRepository.allPlaylists));
      return;
    }
    final success = await _onAudioQuery.createPlaylist(name);
    if (success) {
      await _queryPlaylists();
    } else {
      emit(PlaylistsSuccessState(allPlaylists: _queryRepository.allPlaylists));
    }
  }

  Future<void> removePlayList({required int id}) async {
    // Playlist operations are not supported on iOS due to plugin limitations
    if (Platform.isIOS) {
      emit(PlaylistsSuccessState(allPlaylists: _queryRepository.allPlaylists));
      return;
    }
    emit(PlaylistsLoadingState());
    
    final hasPermission = await _onAudioQuery.permissionsStatus();
    if (!hasPermission) {
      await _queryRepository.softDeletePlaylist(id);
      await _queryPlaylists();
      return;
    }

    final success = await _onAudioQuery.removePlaylist(id);

    // Fallback: Soft-delete the playlist if native deletion failed
    // This often happens on Android 10+ due to Scoped Storage restrictions.
    if (!success) {
      await _queryRepository.softDeletePlaylist(id);
    }

    await _queryPlaylists();
  }

  Future<void> addTrackToPlayList(
      {required int playlistId, required int trackId}) async {
    // Playlist operations are not supported on iOS due to plugin limitations
    if (Platform.isIOS) return;
    final hasPermission = await _onAudioQuery.permissionsStatus();
    if (!hasPermission) return;

    final success = await _onAudioQuery.addToPlaylist(playlistId, trackId);
    if (success) {
      await queryPlaylistTracks(id: playlistId);
      await _queryPlaylists();
    }
  }

  Future<void> removeTrackFromPlayList(
      {required int playlistId, required int trackId}) async {
    // Playlist operations are not supported on iOS due to plugin limitations
    if (Platform.isIOS) return;
    
    final hasPermission = await _onAudioQuery.permissionsStatus();
    if (!hasPermission) {
      await _queryRepository.softDeleteTrackFromPlaylist(playlistId, trackId);
      await queryPlaylistTracks(id: playlistId);
      await _queryPlaylists();
      return;
    }

    final success = await _onAudioQuery.removeFromPlaylist(playlistId, trackId);

    // Fallback: Soft-delete the track if native deletion failed
    // This often happens on Android 10+ due to Scoped Storage restrictions.
    if (!success) {
      await _queryRepository.softDeleteTrackFromPlaylist(playlistId, trackId);
    }

    await queryPlaylistTracks(id: playlistId);
    await _queryPlaylists();
  }

  Future<void> _queryPlaylists() async {
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
