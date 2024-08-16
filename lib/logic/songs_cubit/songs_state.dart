import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

@immutable
sealed class SongsState {}

final class SongsInitialState extends SongsState {}

final class SongsLoadingState extends SongsState {}

final class SongsFailureState extends SongsState {
  final String message;

  SongsFailureState({required this.message});
}

final class SongsSuccessState extends SongsState {
  final List<SongModel> allSongs;

  SongsSuccessState({required this.allSongs});
}
