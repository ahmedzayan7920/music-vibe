import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_vibe/views/widgets/common/list_tile_leading.dart';
import 'package:music_vibe/views/widgets/common/song_list_tile_trailing.dart';
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
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
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
        if (currentIndex != previousIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToPlayingSong(sequence.length);
          });
        }
        return ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          itemCount: sequence.length,
          initialScrollIndex: currentIndex,
          initialAlignment: 0,
          itemBuilder: (context, index) {
            return ListTile(
              selected: index == currentIndex,
              leading: ListTileLeading(
                id: int.parse(sequence[index].tag.id),
                type: ArtworkType.AUDIO,
                placeholderIcon: Icons.music_note_outlined,
              ),
              title: Text(
                sequence[index].tag.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: SongListTileTrailing(
                  songId: int.parse(sequence[index].tag.id)),
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
      final positions = itemPositionsListener.itemPositions.value;

      if (positions.isNotEmpty) {
        final visibleIndices = positions.map((p) => p.index).toList()..sort();
        final minVisible = visibleIndices.first;
        final maxVisible = visibleIndices.last;

        if (currentIndex >= minVisible && currentIndex <= maxVisible) {
          previousIndex = currentIndex;
          return;
        }

        const animateThreshold = 30;
        final distance = currentIndex < minVisible
            ? (minVisible - currentIndex)
            : (currentIndex - maxVisible);

        if (distance > animateThreshold) {
          itemScrollController.jumpTo(
            index: currentIndex,
            alignment: 0,
          );
        } else {
          itemScrollController.scrollTo(
            index: currentIndex,
            duration: const Duration(milliseconds: 250),
            alignment: 0,
          );
        }
      } else {
        itemScrollController.jumpTo(
          index: currentIndex,
          alignment: 0,
        );
      }
      previousIndex = currentIndex;
    }
  }
}
