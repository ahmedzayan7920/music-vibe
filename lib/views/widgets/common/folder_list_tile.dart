import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

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
        folder.replaceFirst(RegExp(r'^/storage/emulated/0/?'), ''),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Center(
          child: Icon(Icons.folder_outlined),
        ),
      ),
    );
  }
}
