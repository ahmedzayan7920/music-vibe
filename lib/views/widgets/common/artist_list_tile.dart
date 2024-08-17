import 'package:flutter/material.dart';
import 'package:music_vibe/views/widgets/common/list_tile_leading.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../screens/songs_screen.dart';

class ArtistListTile extends StatelessWidget {
  const ArtistListTile({super.key, required this.artist});
  final ArtistModel artist;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongsScreen(
              title: artist.artist,
              type: AudiosFromType.ARTIST,
            ),
          ),
        );
      },
      title: Text(
        artist.artist.toString(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        "${artist.numberOfTracks} songs",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: ListTileLeading(
        id: artist.id,
        type: ArtworkType.ARTIST,
        placeholderIcon: Icons.person_pin_outlined,
      ),
    );
  }
}
