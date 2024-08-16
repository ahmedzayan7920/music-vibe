import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/handlers/song_handler.dart';

class PlayerSongsList extends StatefulWidget {
  const PlayerSongsList({super.key});

  @override
  State<PlayerSongsList> createState() => _PlayerSongsListState();
}

class _PlayerSongsListState extends State<PlayerSongsList> {
  final ItemScrollController itemScrollController = ItemScrollController();
  int? previousIndex;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: getIt<MyAudioHandler>().audioPlayer.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final sequence = state?.sequence ?? [];
        currentIndex = state?.currentIndex ?? 0;
        // Only scroll if the current index has changed
        if (currentIndex != previousIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToPlayingSong(sequence.length);
          });
        }
        return ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          itemCount: sequence.length,
          initialScrollIndex: currentIndex,
          initialAlignment: 0,
          itemBuilder: (context, index) {
            return ListTile(
              selected: index == currentIndex,
              leading: SizedBox(
                width: 50,
                height: 50,
                child: Center(
                  child: QueryArtworkWidget(
                    id: int.parse(sequence[index].tag.id),
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const Icon(Icons.music_note),
                  ),
                ),
              ),
              title: Text(
                sequence[index].tag.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                getIt<MyAudioHandler>().seek(Duration.zero, index: index);
              },
            );
          },
        );
      },
    );
  }

  void _scrollToPlayingSong(int sequenceLength) {
    if (currentIndex != previousIndex &&
        currentIndex >= 0 &&
        currentIndex < sequenceLength) {
      itemScrollController.jumpTo(
        index: currentIndex,
        // duration: const Duration(milliseconds: 500),
        alignment: 0,
      );
      previousIndex = currentIndex;
    }
  }
}
