import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/logic/bottom_navigation_cubit/bottom_navigation_cubit.dart';

import '../../../logic/bottom_navigation_cubit/bottom_navigation_state.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note_outlined),
              label: "Songs",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.featured_play_list_outlined),
              label: "Playlists",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.album_outlined),
              label: "Albums",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: "Artists",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              label: "Favorites",
            ),
          ],
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          currentIndex: context
              .read<BottomNavigationCubit>()
              .currentBottomNavigationIndex,
          onTap: (value) {
            context
                .read<BottomNavigationCubit>()
                .setCurrentBottomNavigationIndex(value);
          },
        );
      },
    );
  }
}
