import 'package:flutter/material.dart';

@immutable
sealed class FoldersState {}

final class FoldersInitialState extends FoldersState {}

final class FoldersLoadingState extends FoldersState {}

final class FoldersFailureState extends FoldersState {
  final String message;

  FoldersFailureState({required this.message});
}

final class FoldersSuccessState extends FoldersState {
  final List<String> allFolders;

  FoldersSuccessState({required this.allFolders});
}
