import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/handlers/track_handler.dart';

class RepeatButton extends StatelessWidget {
  const RepeatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoopMode>(
      stream: getIt<MyAudioHandler>().audioPlayer.loopModeStream,
      builder: (context, snapshot) {
        final loopMode = snapshot.data ?? LoopMode.off;
        const repeatModes = [
          LoopMode.off,
          LoopMode.all,
          LoopMode.one,
        ];
        final index = repeatModes.indexOf(loopMode);
        final icons = [
          const Icon(Icons.repeat),
          const Icon(Icons.repeat, color: Colors.orangeAccent),
          const Icon(Icons.repeat_one, color: Colors.orangeAccent),
        ];

        return IconButton(
          iconSize: 32,
          icon: icons[index],
          onPressed: () {
            getIt<MyAudioHandler>().audioPlayer.setLoopMode(
                  repeatModes[(index + 1) % repeatModes.length],
                );
          },
        );
      },
    );
  }
}
