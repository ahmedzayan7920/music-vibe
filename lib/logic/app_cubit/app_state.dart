import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
sealed class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

final class AppInitialState extends AppState {
  const AppInitialState();
}

final class AppDarkState extends AppState {
  const AppDarkState();
}

final class AppLightState extends AppState {
  const AppLightState();
}
