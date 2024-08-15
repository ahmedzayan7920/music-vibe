import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../handlers/dependency_injection.dart';
import '../../screens/player_screen.dart';

class HomeSongs extends StatelessWidget {
  const HomeSongs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      future: getIt<OnAudioQuery>().querySongs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasData == false) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data?.isEmpty ?? false) {
          return const Center(child: Text("No songs found"));
        } else {
          List<SongModel> allSongs = snapshot.data ?? [];
          return ListView.builder(
            itemCount: allSongs.length,
            itemBuilder: (context, index) {
              SongModel song = allSongs[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerScreen(
                        songs: allSongs,
                        index: index,
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
            },
          );
        }
      },
    );
  }
}
