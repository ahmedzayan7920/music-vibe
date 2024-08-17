import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

@immutable
sealed class FavoritesState {}

final class FavoritesInitialState extends FavoritesState {}


final class FavoritesSuccessState extends FavoritesState {
  final List<SongModel> allFavoriteSongs;

  FavoritesSuccessState({required this.allFavoriteSongs});
}
