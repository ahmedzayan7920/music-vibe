import 'package:flutter/material.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/handlers/track_handler.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: getIt<MyAudioHandler>().audioPlayer.shuffleModeEnabledStream,
      builder: (context, snapshot) {
        bool isEnabled = snapshot.data ?? false;
        return IconButton(
          onPressed: () async {
            if (!isEnabled) {
              await getIt<MyAudioHandler>().audioPlayer.shuffle();
            }
            await getIt<MyAudioHandler>()
                .audioPlayer
                .setShuffleModeEnabled(!isEnabled);
          },
          icon: const Icon(Icons.shuffle),
          iconSize: 32,
          color: isEnabled ? Colors.orangeAccent : null,
          splashColor: Colors.transparent,
        );
      },
    );
  }
}
