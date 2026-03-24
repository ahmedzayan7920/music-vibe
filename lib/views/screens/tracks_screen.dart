import 'package:flutter/material.dart';
import 'package:music_vibe/core/di/dependency_injection.dart';
import 'package:music_vibe/repositories/query_repository.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

import '../widgets/common/empty_state.dart';
import '../widgets/common/shuffle_list_tile.dart';
import '../widgets/common/track_list_tile.dart';

class TracksScreen extends StatefulWidget {
  const TracksScreen({super.key, required this.title, required this.type});

  final String title;
  final AudiosFromType type;

  @override
  State<TracksScreen> createState() => _TracksScreenState();
}

class _TracksScreenState extends State<TracksScreen> {
  late List<SongModel> tracks;

  @override
  void initState() {
    tracks = getIt<QueryRepository>().allTracks.where(
      (song) {
        if (widget.type == AudiosFromType.ALBUM) {
          return song.album == widget.title;
        } else if (widget.type == AudiosFromType.GENRE) {
          return song.data.contains(widget.title);
        } else {
          return song.artist == widget.title;
        }
      },
    ).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: (tracks.isEmpty)
          ? const EmptyState(message: 'No Sounds Found')
          : Column(
              children: [
                tracks.isEmpty
                    ? const SizedBox()
                    : ShuffleListTile(tracks: tracks),
                Expanded(
                  child: ListView.builder(
                    itemCount: tracks.length,
                    itemBuilder: (context, index) {
                      return TrackListTile(allTracks: tracks, track: tracks[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
