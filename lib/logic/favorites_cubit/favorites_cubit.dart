import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/repositories/query_repository.dart';

import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final QueryRepository _queryRepository;

  FavoritesCubit({required QueryRepository queryRepository})
      : _queryRepository = queryRepository,
        super(FavoritesInitialState());

  void queryFavoriteTracks() {
    final favorites = _queryRepository.queryFavoriteTracks();
    emit(FavoritesSuccessState(allFavoriteTracks: favorites));
  }

  Future<void> toggleFavorite({required int id}) async {
    final favorites = await _queryRepository.toggleFavorite(id: id);
    emit(FavoritesSuccessState(allFavoriteTracks: favorites));
  }
}
