import 'package:flutter/material.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/handlers/track_handler.dart';

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
              final timeStr = position.toString().split(".")[0];
              return Text(
                timeStr[0] == "0" ? timeStr.substring(2) : timeStr,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<Duration>(
              stream: getIt<MyAudioHandler>().audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration =
                    getIt<MyAudioHandler>().audioPlayer.duration ?? Duration.zero;
                return Slider(
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.2),
                  min: 0.0,
                  max: duration.inMicroseconds.toDouble(),
                  value: position.inMicroseconds
                      .toDouble()
                      .clamp(0.0, duration.inMicroseconds.toDouble()),
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
              final timeStr = duration.toString().split(".")[0];
              return Text(
                timeStr[0] == "0" ? timeStr.substring(2) : timeStr,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}
