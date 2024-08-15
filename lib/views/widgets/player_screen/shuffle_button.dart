import 'package:flutter/material.dart';

import '../../../handlers/dependency_injection.dart';
import '../../../handlers/song_handler.dart';

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
          color: isEnabled ? Theme.of(context).colorScheme.primary : null,
          splashColor: Colors.transparent,
        );
      },
    );
  }
}
