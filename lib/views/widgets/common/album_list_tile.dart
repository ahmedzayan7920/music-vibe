import 'package:flutter/material.dart';
import 'package:music_vibe/views/widgets/common/list_tile_leading.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

import '../../screens/songs_screen.dart';

class AlbumListTile extends StatelessWidget {
  const AlbumListTile({super.key, required this.album});
  final AlbumModel album;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongsScreen(
              title: album.album,
              type: AudiosFromType.ALBUM,
            ),
          ),
        );
      },
      title: Text(
        album.album.toString(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        "${album.numOfSongs} songs",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: ListTileLeading(
        id: album.id,
        type: ArtworkType.ALBUM,
        placeholderIcon: Icons.album_outlined,
      ),
    );
  }
}
