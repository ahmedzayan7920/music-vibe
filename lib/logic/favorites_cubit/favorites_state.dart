import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

@immutable
sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

final class FavoritesInitialState extends FavoritesState {
  const FavoritesInitialState();
}

final class FavoritesSuccessState extends FavoritesState {
  final List<SongModel> allFavoriteTracks;

  const FavoritesSuccessState({required this.allFavoriteTracks});

  @override
  List<Object?> get props => [allFavoriteTracks];
}
