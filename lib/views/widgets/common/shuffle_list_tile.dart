import 'dart:math';

import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/handlers/song_handler.dart';
import '../../screens/player_screen.dart';

class ShuffleListTile extends StatelessWidget {
  const ShuffleListTile({
    super.key,
    required this.songs,
  });
  final List<SongModel> songs;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      textColor: Theme.of(context).colorScheme.primary,
      iconColor: Theme.of(context).colorScheme.primary,
      leading: const SizedBox(
        width: 50,
        height: 50,
        child: Icon(Icons.shuffle_rounded),
      ),
      title: const Text("Shuffle All"),
      onTap: () async {
        await getIt<MyAudioHandler>()
            .audioPlayer
            .setShuffleModeEnabled(true)
            .then(
          (value) {
            if (context.mounted) _goNext(context);
          },
        );
      },
    );
  }

  void _goNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerScreen(
            songs: songs, index: Random.secure().nextInt(songs.length)),
      ),
    );
  }
}
