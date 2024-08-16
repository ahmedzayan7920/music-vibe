import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/handlers/song_handler.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: getIt<MyAudioHandler>().audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final processingState = snapshot.data?.processingState;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return const IconButton(
            onPressed: null,
            icon: Icon(Icons.play_arrow),
          );
        } else if (!getIt<MyAudioHandler>().audioPlayer.playing) {
          return IconButton(
            onPressed: getIt<MyAudioHandler>().play,
            icon: const Icon(Icons.play_arrow),
            color: color,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            onPressed: getIt<MyAudioHandler>().pause,
            icon: const Icon(Icons.pause),
            color: color,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            color: color,
            onPressed: () => getIt<MyAudioHandler>().seek(
              Duration.zero,
            ),
          );
        }
      },
    );
  }
}
