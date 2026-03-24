import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

@immutable
sealed class TracksState {}

final class TracksInitialState extends TracksState {}

final class TracksLoadingState extends TracksState {}

final class TracksFailureState extends TracksState {
  final String message;

  TracksFailureState({required this.message});
}

final class TracksSuccessState extends TracksState {
  final List<SongModel> allTracks;

  TracksSuccessState({required this.allTracks});
}
