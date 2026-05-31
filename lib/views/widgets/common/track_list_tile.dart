import 'package:flutter/material.dart';
import 'package:sonic_vibe/views/widgets/common/track_list_tile_trailing.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

import '../../screens/player_screen.dart';
import 'list_tile_leading.dart';

class TrackListTile extends StatelessWidget {
  const TrackListTile({
    super.key,
    required this.allTracks,
    required this.track,
  });

  final List<SongModel> allTracks;
  final SongModel track;

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
        placeholderIcon: Icons.music_note_outlined,
      ),
      trailing: TrackListTileTrailing(trackId: track.id),
    );
  }
}
