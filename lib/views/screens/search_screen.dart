import 'package:flutter/material.dart';
import 'package:music_vibe/repositories/query_repository.dart';
import 'package:music_vibe/views/widgets/common/shuffle_list_tile.dart';
import 'package:music_vibe/views/widgets/common/track_list_tile.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

import '../../core/di/dependency_injection.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/mini_player.dart';
import '../widgets/search_screen/search_form_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<SongModel> allTracks = getIt<QueryRepository>().allTracks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          SearchFormField(onChanged: getSearchTracks),
          allTracks.isEmpty
              ? const Expanded(child: EmptyState(message: 'No Tracks Found'))
              : Expanded(
                  child: Column(
                    children: [
                      ShuffleListTile(tracks: allTracks),
                      Expanded(
                        child: ListView.builder(
                          itemCount: allTracks.length,
                          itemBuilder: (context, index) {
                            return TrackListTile(
                                allTracks: allTracks, track: allTracks[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      bottomNavigationBar: SafeArea(child: const MiniPlayer()),
    );
  }

  void getSearchTracks(String query) {
    allTracks = getIt<QueryRepository>()
        .allTracks
        .where((e) => e.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {});
  }
}
