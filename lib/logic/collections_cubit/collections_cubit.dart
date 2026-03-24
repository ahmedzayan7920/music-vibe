import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/repositories/query_repository.dart';

import 'collections_state.dart';

class CollectionsCubit extends Cubit<CollectionsState> {
  final QueryRepository _queryRepository;

  CollectionsCubit({required QueryRepository queryRepository})
      : _queryRepository = queryRepository,
        super(CollectionsInitialState());

  Future<void> queryAllCollections() async {
    emit(CollectionsLoadingState());
    if (_queryRepository.allCollections.isEmpty) {
      _queryCollections();
    } else {
      emit(CollectionsSuccessState(allCollections: _queryRepository.allCollections));
    }
  }

  Future<void> refreshQueryAllCollections() async {
    emit(CollectionsLoadingState());
    _queryCollections();
  }

  Future<void> _queryCollections() async {
    final result = await _queryRepository.queryAllCollections();
    result.fold(
      (failure) {
        emit(CollectionsFailureState(message: failure.message));
      },
      (collections) {
        emit(CollectionsSuccessState(allCollections: collections));
      },
    );
  }
}
