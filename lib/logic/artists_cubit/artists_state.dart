import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

@immutable
sealed class ArtistsState {}

final class ArtistsInitialState extends ArtistsState {}

final class ArtistsLoadingState extends ArtistsState {}

final class ArtistsFailureState extends ArtistsState {
  final String message;

  ArtistsFailureState({required this.message});
}

final class ArtistsSuccessState extends ArtistsState {
  final List<ArtistModel> allArtists;

  ArtistsSuccessState({required this.allArtists});
}
