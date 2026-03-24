import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/repositories/query_repository.dart';

import 'creators_state.dart';

class CreatorsCubit extends Cubit<CreatorsState> {
  final QueryRepository _queryRepository;

  CreatorsCubit({required QueryRepository queryRepository})
      : _queryRepository = queryRepository,
        super(CreatorsInitialState());

  Future<void> queryAllCreators() async {
    emit(CreatorsLoadingState());
    if (_queryRepository.allCreators.isEmpty) {
      _queryCreators();
    } else {
      emit(CreatorsSuccessState(allCreators: _queryRepository.allCreators));
    }
  }

  Future<void> refreshQueryAllCreators() async {
    emit(CreatorsLoadingState());
    _queryCreators();
  }

  Future<void> _queryCreators() async {
    final result = await _queryRepository.queryAllCreators();
    result.fold(
      (failure) {
        emit(CreatorsFailureState(message: failure.message));
      },
      (creators) {
        emit(CreatorsSuccessState(allCreators: creators));
      },
    );
  }
}
