import 'package:flutter/material.dart';
import 'package:music_vibe/core/di/dependency_injection.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../core/handlers/song_handler.dart';
import '../widgets/player_screen/player_songs_list.dart';
import '../widgets/player_screen/action_buttons.dart';
import '../widgets/player_screen/time_section.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    super.key,
    required this.songs,
    required this.index,
    this.reOpen = false,
  });
  final List<SongModel> songs;
  final int index;
  final bool reOpen;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  void initState() {
    super.initState();
    widget.reOpen == true ? null : _initAudioSource();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Playing Now"),
        elevation: 2,
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: PlayerSongsList(),
              ),
              TimeSection(),
              ActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  void _initAudioSource( ) async {
    await getIt<MyAudioHandler>().setupPlaylist(widget.songs, widget.index);
   
  }
}
