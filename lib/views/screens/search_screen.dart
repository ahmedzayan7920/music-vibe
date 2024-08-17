import 'package:flutter/material.dart';
import 'package:music_vibe/repositories/query_repository.dart';
import 'package:music_vibe/views/widgets/common/shuffle_list_tile.dart';
import 'package:music_vibe/views/widgets/common/song_list_tile.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../core/di/dependency_injection.dart';
import '../widgets/mini_player.dart';
import '../widgets/search_screen/search_form_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<SongModel> allSongs = getIt<QueryRepository>().allSongs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          SearchFormField(onChanged: getSearchSongs),
          allSongs.isEmpty
              ? Center(
                  child: Text(
                    "No Sounds Found",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                )
              : Expanded(
                  child: Column(
                    children: [
                      ShuffleListTile(songs: allSongs),
                      Expanded(
                        child: ListView.builder(
                          itemCount: allSongs.length,
                          itemBuilder: (context, index) {
                            return SongListTile(
                                allSongs: allSongs, song: allSongs[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }

  getSearchSongs(String query) {
    allSongs = getIt<QueryRepository>()
        .allSongs
        .where((e) => e.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {});
  }
}
