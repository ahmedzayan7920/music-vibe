import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/handlers/track_handler.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({super.key, this.color, this.size, this.iconSize});
  final Color? color;
  final double? size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: getIt<MyAudioHandler>().audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final processingState = snapshot.data?.processingState;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: size ?? 32.0,
            height: size ?? 32.0,
            child: CircularProgressIndicator(
              color: color,
              strokeWidth: (size ?? 32.0) / 8,
            ),
          );
        } else if (!getIt<MyAudioHandler>().audioPlayer.playing) {
          return IconButton(
            onPressed: getIt<MyAudioHandler>().play,
            iconSize: iconSize,
            icon: const Icon(Icons.play_arrow),
            color: color,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            onPressed: getIt<MyAudioHandler>().pause,
            iconSize: iconSize,
            icon: const Icon(Icons.pause),
            color: color,
          );
        } else {
          return IconButton(
            iconSize: iconSize,
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
