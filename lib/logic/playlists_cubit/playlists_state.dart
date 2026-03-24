import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

@immutable
sealed class PlaylistsState extends Equatable {
  const PlaylistsState();

  @override
  List<Object?> get props => [];
}

final class PlaylistsInitialState extends PlaylistsState {
  const PlaylistsInitialState();
}

final class PlaylistsLoadingState extends PlaylistsState {
  const PlaylistsLoadingState();
}

final class PlaylistsFailureState extends PlaylistsState {
  final String message;

  const PlaylistsFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class PlaylistsSuccessState extends PlaylistsState {
  final List<PlaylistModel> allPlaylists;

  const PlaylistsSuccessState({required this.allPlaylists});

  @override
  List<Object?> get props => [allPlaylists];
}

final class PlaylistTracksLoadingState extends PlaylistsState {
  const PlaylistTracksLoadingState();
}

final class PlaylistTracksFailureState extends PlaylistsState {
  final String message;

  const PlaylistTracksFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class PlaylistTracksSuccessState extends PlaylistsState {
  final List<SongModel> allTracks;

  const PlaylistTracksSuccessState({required this.allTracks});

  @override
  List<Object?> get props => [allTracks];
}
