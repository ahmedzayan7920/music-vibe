import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/views/widgets/home_screen/home_albums.dart';
import 'package:music_vibe/views/widgets/home_screen/home_artists.dart';
import 'package:music_vibe/views/widgets/home_screen/home_favorites.dart';
import 'package:music_vibe/views/widgets/home_screen/home_playlists.dart';
import 'package:music_vibe/views/widgets/home_screen/home_songs.dart';
import 'package:music_vibe/views/widgets/mini_player.dart';

import '../../logic/bottom_navigation_cubit/bottom_navigation_cubit.dart';
import '../../logic/bottom_navigation_cubit/bottom_navigation_state.dart';
import '../widgets/dark_light_switch.dart';
import '../widgets/home_screen/home_bottom_navigation_bar.dart';
import '../widgets/home_screen/home_floating_action_button.dart';
import '../widgets/home_screen/home_folders.dart';
import '../widgets/home_screen/search_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavigationCubit(),
      child: BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
        buildWhen: (previous, current) =>
            current is BottomNavigationIndexChangedState,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: const Text("Music Vibe"),
              leadingWidth: 72,
              leading: const DarkLightSwitch(),
              actions: const [SearchButton()],
            ),
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                context
                    .read<BottomNavigationCubit>()
                    .setCurrentBottomNavigationIndex(index);
              },
              children: [
                HomeSongs(),
                HomePlaylists(),
                HomeAlbums(),
                HomeArtists(),
                if (Platform.isAndroid) HomeFolders(),
                HomeFavorites(),
              ],
            ),
            bottomNavigationBar: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                const MiniPlayer(),
                HomeBottomNavigationBar(pageController: _pageController),
              ],
            ),
            floatingActionButton: context
                        .read<BottomNavigationCubit>()
                        .currentBottomNavigationIndex ==
                    1
                ? const HomeFloatingActionButton()
                : null,
          );
        },
      ),
    );
  }
}
