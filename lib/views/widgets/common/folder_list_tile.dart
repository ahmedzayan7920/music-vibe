import 'package:flutter/material.dart';
import 'package:music_vibe/views/widgets/common/list_tile_leading.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../screens/songs_screen.dart';

class FolderListTile extends StatelessWidget {
  const FolderListTile({super.key, required this.folder});
  final String folder;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongsScreen(
              title: folder,
              type: AudiosFromType.GENRE,
            ),
          ),
        );
      },
      title: Text(
        folder,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: ListTileLeading(
        id: folder.hashCode,
        type: ArtworkType.GENRE,
        placeholderIcon: Icons.album_outlined,
      ),
    );
  }
}
