import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_vibe/repositories/query_repository.dart';

import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final QueryRepository _queryRepository;

  FavoritesCubit({required QueryRepository queryRepository})
      : _queryRepository = queryRepository,
        super(FavoritesInitialState());

  void queryFavorites() {
    final favorites = _queryRepository.queryFavoriteTracks();
    emit(FavoritesSuccessState(allFavoriteTracks: favorites));
  }

  void toggleFavorite({required int id}) {
    final favorites = _queryRepository.toggleFavorite(id: id);
    emit(FavoritesSuccessState(allFavoriteTracks: favorites));
  }
}
