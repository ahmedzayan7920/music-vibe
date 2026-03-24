import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

@immutable
sealed class CreatorsState {}

final class CreatorsInitialState extends CreatorsState {}

final class CreatorsLoadingState extends CreatorsState {}

final class CreatorsFailureState extends CreatorsState {
  final String message;

  CreatorsFailureState({required this.message});
}

final class CreatorsSuccessState extends CreatorsState {
  final List<ArtistModel> allCreators;

  CreatorsSuccessState({required this.allCreators});
}
