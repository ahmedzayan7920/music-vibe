import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../handlers/dependency_injection.dart';
import '../../../handlers/song_handler.dart';

class PreviousButton extends StatelessWidget {
  const PreviousButton({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: getIt<MyAudioHandler>().audioPlayer.sequenceStateStream,
      builder: (context, snapshot) {
        return IconButton(
          onPressed: getIt<MyAudioHandler>().audioPlayer.hasPrevious
              ? getIt<MyAudioHandler>().skipToPrevious
              : null,
          icon: const Icon(Icons.skip_previous),
        );
      },
    );
  }
}
