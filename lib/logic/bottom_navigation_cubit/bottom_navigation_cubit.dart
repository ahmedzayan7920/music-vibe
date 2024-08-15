
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit() : super(BottomNavigationInitialState());
  int _currentBottomNavigationIndex = 0;

  int get currentBottomNavigationIndex => _currentBottomNavigationIndex;

  setCurrentBottomNavigationIndex(int index) {
    _currentBottomNavigationIndex = index;
    emit(BottomNavigationIndexChangedState());
  }
}
