import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/logic/favorites_cubit/favorites_cubit.dart';
import 'package:music_vibe/logic/favorites_cubit/favorites_state.dart';
import 'package:music_vibe/repositories/query_repository.dart';

import '../../../core/di/dependency_injection.dart';

class AddRemoveFavoriteIcon extends StatelessWidget {
  const AddRemoveFavoriteIcon({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<FavoritesCubit>(),
      child: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          return IconButton(
            onPressed: () {
              getIt<FavoritesCubit>().toggleFavorite(
                id: id,
              );
            },
            icon: Icon(
              getIt<QueryRepository>().favoriteIds.contains(id)
                  ? Icons.favorite
                  : Icons.favorite_outline,
            ),
          );
        },
      ),
    );
  }
}
