import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

@immutable
sealed class AlbumsState {}

final class AlbumsInitialState extends AlbumsState {}

final class AlbumsLoadingState extends AlbumsState {}

final class AlbumsFailureState extends AlbumsState {
  final String message;

  AlbumsFailureState({required this.message});
}

final class AlbumsSuccessState extends AlbumsState {
  final List<AlbumModel> allAlbums;

  AlbumsSuccessState({required this.allAlbums});
}
