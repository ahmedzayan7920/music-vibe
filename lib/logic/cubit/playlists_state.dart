
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

@immutable
sealed class PlaylistsState {}

final class PlaylistsInitialState extends PlaylistsState {}
final class PlaylistsLoadingState extends PlaylistsState {}
final class PlaylistsFailureState extends PlaylistsState {
  final String message;

  PlaylistsFailureState({required this.message});
}
final class PlaylistsSuccessState extends PlaylistsState {
  final List<PlaylistModel> allPlaylists;

  PlaylistsSuccessState({required this.allPlaylists});
}
