import 'package:flutter/material.dart';

import '../../../handlers/dependency_injection.dart';
import '../../../handlers/song_handler.dart';

class TimeSection extends StatelessWidget {
  const TimeSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          StreamBuilder<Duration>(
            stream: getIt<MyAudioHandler>().audioPlayer.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              if (position.toString().split(".")[0][0] == "0") {
                return Text(position.toString().split(".")[0].substring(2));
              } else {
                return Text(position.toString().split(".")[0]);
              }
            },
          ),
          Expanded(
            child: StreamBuilder<Duration>(
              stream: getIt<MyAudioHandler>().audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return Slider(
                  min: 0.0,
                  max: getIt<MyAudioHandler>()
                          .audioPlayer
                          .duration
                          ?.inMicroseconds
                          .toDouble() ??
                      0.0,
                  value: getIt<MyAudioHandler>()
                              .audioPlayer
                              .duration
                              ?.inMicroseconds
                              .toDouble() ==
                          null
                      ? 0.0
                      : position.inMicroseconds.toDouble(),
                  onChanged: (double value) {
                    getIt<MyAudioHandler>()
                        .seek(Duration(microseconds: value.toInt()));
                  },
                );
              },
            ),
          ),
          StreamBuilder<Duration?>(
            stream: getIt<MyAudioHandler>().audioPlayer.durationStream,
            builder: (context, snapshot) {
              final duration = snapshot.data ?? Duration.zero;
              if (duration.toString().split(".")[0][0] == "0") {
                return Text(duration.toString().split(".")[0].substring(2));
              } else {
                return Text(duration.toString().split(".")[0]);
              }
            },
          ),
        ],
      ),
    );
  }
}
