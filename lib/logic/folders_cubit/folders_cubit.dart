import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/repositories/query_repository.dart';

import 'folders_state.dart';

class FoldersCubit extends Cubit<FoldersState> {
  final QueryRepository _queryRepository;

  FoldersCubit({required QueryRepository queryRepository})
      : _queryRepository = queryRepository,
        super(FoldersInitialState());

  Future<void> queryAllFolders() async {
    // Folders are not supported on iOS due to plugin limitations
    if (Platform.isIOS) {
      emit(FoldersSuccessState(allFolders: []));
      return;
    }
    emit(FoldersLoadingState());
    if (_queryRepository.allFolders.isEmpty) {
      _queryFolders();
    } else {
      emit(FoldersSuccessState(allFolders: _queryRepository.allFolders));
    }
  }

  Future<void> refreshQueryAllFolders() async {
    // Folders are not supported on iOS due to plugin limitations
    if (Platform.isIOS) {
      emit(FoldersSuccessState(allFolders: []));
      return;
    }
    emit(FoldersLoadingState());
    _queryFolders();
  }

  Future<void> _queryFolders() async {
    final result = await _queryRepository.queryAllFolders();
    result.fold(
      (failure) {
        emit(FoldersFailureState(message: failure.message));
      },
      (folders) {
        emit(FoldersSuccessState(allFolders: folders));
      },
    );
  }
}
