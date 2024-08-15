
import 'package:flutter/material.dart';

@immutable
sealed class BottomNavigationState {}

final class BottomNavigationInitialState extends BottomNavigationState {}
final class BottomNavigationIndexChangedState extends BottomNavigationState {}
