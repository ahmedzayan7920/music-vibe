import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

import '../../screens/player_screen.dart';
import '../common/list_tile_leading.dart';
import 'playlist_track_list_tile_trailing.dart';

class PlaylistTrackListTile extends StatelessWidget {
  const PlaylistTrackListTile({
    super.key,
    required this.allTracks,
    required this.track,
    required this.playlistId,
  });

  final List<SongModel> allTracks;
  final SongModel track;
  final int playlistId;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerScreen(
              songs: allTracks,
              index: allTracks.indexOf(track),
            ),
          ),
        );
      },
      title: Text(
        track.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        track.artist ?? "unknown",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: ListTileLeading(
        id: track.id,
        type: ArtworkType.AUDIO,
        placeholderIcon: Icons.graphic_eq,
      ),
      trailing: PlaylistTrackListTileTrailing(playlistId: playlistId, trackId: track.id),
    );
  }
}
