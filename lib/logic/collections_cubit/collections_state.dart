import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

@immutable
sealed class CollectionsState {}

final class CollectionsInitialState extends CollectionsState {}

final class CollectionsLoadingState extends CollectionsState {}

final class CollectionsFailureState extends CollectionsState {
  final String message;

  CollectionsFailureState({required this.message});
}

final class CollectionsSuccessState extends CollectionsState {
  final List<AlbumModel> allCollections;

  CollectionsSuccessState({required this.allCollections});
}
