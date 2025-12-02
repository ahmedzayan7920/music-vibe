import 'package:flutter/material.dart';
import 'package:music_vibe/core/di/dependency_injection.dart';
import 'package:music_vibe/repositories/query_repository.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

import '../widgets/common/empty_state.dart';
import '../widgets/common/shuffle_list_tile.dart';
import '../widgets/common/song_list_tile.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key, required this.title, required this.type});

  final String title;
  final AudiosFromType type;

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  late List<SongModel> songs;

  @override
  void initState() {
    songs = getIt<QueryRepository>().allSongs.where(
      (song) {
        if (widget.type == AudiosFromType.ALBUM) {
          return song.album == widget.title;
        } else if (widget.type == AudiosFromType.GENRE) {
          return song.data.contains(widget.title);
        } else {
          return song.artist == widget.title;
        }
      },
    ).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: (songs.isEmpty)
          ? const EmptyState(message: 'No Sounds Found')
          : Column(
              children: [
                songs.isEmpty
                    ? const SizedBox()
                    : ShuffleListTile(songs: songs),
                Expanded(
                  child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      return SongListTile(allSongs: songs, song: songs[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
