import 'package:flutter/material.dart';

class AddRemoveFavoriteIcon extends StatelessWidget {
  const AddRemoveFavoriteIcon({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(
        Icons.favorite_outline,
      ),
    );
    // return BlocProvider.value(
    //   value: getIt<MusicPlayerCubit>(),
    //   child: BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
    //     buildWhen: (previous, current) =>
    //         current is MusicPlayerAddRemoveFavoriteSongState,
    //     builder: (context, state) {
    //       return IconButton(
    //         onPressed: () {
    //           getIt<MusicPlayerCubit>().toggleFavorite(
    //             id: id,
    //           );
    //         },
    //         icon: Icon(
    //           getIt<MusicPlayerCubit>().favoriteSongsIds.contains(id)
    //               ? Icons.favorite
    //               : Icons.favorite_outline,
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
