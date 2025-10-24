import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_vibe/views/widgets/common/list_tile_leading.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../core/di/dependency_injection.dart';
import '../../core/handlers/song_handler.dart';
import '../screens/player_screen.dart';
import 'player_screen/play_pause_button.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  Offset? _dragStartPos;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: getIt<MyAudioHandler>().audioPlayer.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final sequence = state?.sequence ?? [];
        final index = state?.currentIndex ?? 0;

        if (sequence.isEmpty || index >= sequence.length) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onHorizontalDragStart: (details) => _dragStart(details),
          onHorizontalDragEnd: (details) => _dragEnd(details),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              tileColor: Theme.of(context).colorScheme.primary,
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      PlayerScreen(
                    songs: const [],
                    index: index,
                    reOpen: true,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    final tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ));
              },
              leading: ListTileLeading(
                id: int.parse(sequence[index].tag.id),
                type: ArtworkType.AUDIO,
                placeholderIcon: Icons.music_note_outlined,
              ),
              title: Text(
                sequence[index].tag.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                sequence[index].tag.artist ?? "unknown",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: const PlayPauseButton(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void _dragStart(DragStartDetails details) {
    _dragStartPos = details.globalPosition;
  }

  void _dragEnd(DragEndDetails details) {
    if (_dragStartPos == null) return;

    final distance = (details.globalPosition - _dragStartPos!).dx;
    final isHorizontalSwipe =
        distance.abs() > 100; // Adjust distance threshold as needed

    if (isHorizontalSwipe) {
      final velocity = details.primaryVelocity!;
      if (velocity < 0 && getIt<MyAudioHandler>().audioPlayer.hasNext) {
        getIt<MyAudioHandler>().skipToNext();
      } else if (velocity > 0 &&
          getIt<MyAudioHandler>().audioPlayer.hasPrevious) {
        getIt<MyAudioHandler>().skipToPrevious();
      }
    }

    _dragStartPos = null;
  }
}
