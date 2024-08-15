import 'package:flutter/material.dart';
import 'package:music_vibe/views/widgets/mini_player.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Music Vibe"),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: OnAudioQuery().querySongs(),
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
      ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }
}
