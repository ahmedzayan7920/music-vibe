import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../screens/player_screen.dart';
import '../common/list_tile_leading.dart';
import 'playlist_song_list_tile_trailing.dart';

class PlaylistSongListTile extends StatelessWidget {
  const PlaylistSongListTile({
    super.key,
    required this.allSongs,
    required this.song,
    required this.playlistId,
  });

  final List<SongModel> allSongs;
  final SongModel song;
  final int playlistId;

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
      leading: ListTileLeading(
        id: song.id,
        type: ArtworkType.AUDIO,
        placeholderIcon: Icons.music_note_outlined,
      ),
      trailing: PlaylistSongListTileTrailing(playlistId: playlistId, songId: song.id),
    );
  }
}
