

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../screens/player_screen.dart';

class SongListTile extends StatelessWidget {
  const SongListTile({
    super.key,
    required this.allSongs,
    required this.song,
  });

  final List<SongModel> allSongs;
  final SongModel song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerScreen(
              songs: allSongs,
              index: allSongs.indexOf(song),
            ),
          ),
        );
      },
      title: Text(
        song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.artist ?? "unknown",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Center(
          child: QueryArtworkWidget(
            id: song.id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: const Icon(Icons.music_note),
          ),
        ),
      ),
    );
  }
}
