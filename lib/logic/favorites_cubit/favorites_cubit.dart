import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/repositories/query_repository.dart';

import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final QueryRepository _queryRepository;

  FavoritesCubit({required QueryRepository queryRepository})
      : _queryRepository = queryRepository,
        super(FavoritesInitialState());

  queryFavorites() {
    final favorites = _queryRepository.queryFavoriteSongs();
    emit(FavoritesSuccessState(allFavoriteSongs: favorites));
  }

  toggleFavorite({required int id}) {
    final favorites = _queryRepository.toggleFavorite(id: id);
    emit(FavoritesSuccessState(allFavoriteSongs: favorites));
  }
}
