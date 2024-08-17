import 'package:flutter/material.dart';
import 'package:music_vibe/core/di/dependency_injection.dart';
import 'package:music_vibe/repositories/query_repository.dart';
import 'package:on_audio_query/on_audio_query.dart';

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
          ? Center(
              child: Text(
                "No Sounds Found",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
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
